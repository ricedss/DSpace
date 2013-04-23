/*
 * ECEDataCleaner.java
 *
 * Version: $Revision: ? $
 *
 * Date: $Date: 2008-12-17 (Wed, 17 Dec 2008) $
 *
 * Copyright (c) 2002-2005, Hewlett-Packard Company and Massachusetts
 * Institute of Technology.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 * - Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * - Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * - Neither the name of the Hewlett-Packard Company nor the name of the
 * Massachusetts Institute of Technology nor the names of their
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */

package org.dspace.app.util;

import java.io.File;
import java.lang.Exception;
import java.io.FileWriter;
import java.io.PrintWriter;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;

import org.dspace.content.ItemIterator;
import org.dspace.content.DCValue;
import org.dspace.content.Collection;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.core.Constants;
import org.dspace.eperson.EPerson;
import org.dspace.handle.HandleManager;


/**
 * The code will fix the metadata problem in ECE publication database.
 *
 * @author  Ying Jin
 * @version $Revision: ? $
 */

public class ECEDataCleaner
{
        static boolean isTest = false;

        static boolean isResume = false;

        static PrintWriter mapOut = null;

        public static void main(String[] argv) throws Exception
        {
            // create an options object and populate it
            CommandLineParser parser = new PosixParser();

            Options options = new Options();

            options.addOption("f", "fix", false, "Fix data in DSpace");
            options.addOption("c", "collection", true,
                    "destination collection(s) Handle or database ID");
            options.addOption("m", "mapfile", true, "mapfile items in mapfile");
            options.addOption("e", "eperson", true, 
                    "email of eperson doing importing");
            options.addOption("t", "test", false,
                    "test run - do not actually import items");

            options.addOption("h", "help", false, "help");

            CommandLine line = parser.parse(options, argv);

            String command = null; // add replace remove, etc
            String mapfile = null;
            String eperson = null; // db ID or email
            String[] collections = null; // db ID or handles
            int status = 0;

            if (line.hasOption('h'))
            {
                HelpFormatter myhelp = new HelpFormatter();
                myhelp.printHelp("ItemImport\n", options);
                System.out
                        .println("\nfixing data:    ECEDataCleaner -f -e eperson -c collection -m mapfile");
                System.out
                        .println("testing run:  ECEDataCleaner -e eperson -m mapfile -c collection -t");

                System.exit(0);
            }

            if (line.hasOption('f'))
            {
                command = "fix";
            }

            if (line.hasOption('t'))
            {
                isTest = true;
                System.out.println("**Test Run** - not actually fixing data.");
            }

            if (line.hasOption('m')) // mapfile
            {
                mapfile = line.getOptionValue('m');
            }

            if (line.hasOption('e')) // eperson
            {
                eperson = line.getOptionValue('e');
            }

            if (line.hasOption('c')) // collections
            {
                collections = line.getOptionValues('c');
            }

            // now validate
            // must have a command set
            if (command == null)
            {
                System.out
                        .println("Error - must run with fix -f (run with -h flag for details)");
                System.exit(1);
            }
            else if (command.equals("fix"))
            {
                if (mapfile == null)
                {
                    System.out
                            .println("Error - a map file to hold fixing results must be specified");
                    System.out.println(" (run with -h flag for details)");
                    System.exit(1);
                }

                if (eperson == null)
                {
                    System.out
                            .println("Error - an eperson to do the fixing must be specified");
                    System.out.println(" (run with -h flag for details)");
                    System.exit(1);
                }

                if (collections == null)
                {
                    System.out
                            .println("Error - at least one destination collection must be specified");
                    System.out.println(" (run with -h flag for details)");
                    System.exit(1);
                }
            }


            // do checks around mapfile - if mapfile exists and 'add' is selected,
            // resume must be chosen
            File myFile = new File(mapfile);

            if (myFile.exists() && command.equals("fix") && !isResume)
            {
                System.out.println("Error - the mapfile " + mapfile
                        + " already exists.");
                System.out
                        .println("Either delete it or use --resume if attempting to resume an aborted fixing.");
                System.exit(1);
            }

            ECEDataCleaner mycleaner = new ECEDataCleaner();

            // create a context
            Context c = new Context();

            // find the EPerson, assign to context
            EPerson myEPerson = null;

            if (eperson.indexOf('@') != -1)
            {
                // @ sign, must be an email
                myEPerson = EPerson.findByEmail(c, eperson);
            }
            else
            {
                myEPerson = EPerson.find(c, Integer.parseInt(eperson));
            }

            if (myEPerson == null)
            {
                System.out.println("Error, eperson cannot be found: " + eperson);
                System.exit(1);
            }

            c.setCurrentUser(myEPerson);

            // find collections
            Collection[] mycollections = null;

            // don't need to validate collections set if command is "delete"
            System.out.println("Destination collections:");

            mycollections = new Collection[collections.length];

            // validate each collection arg to see if it's a real collection
            for (int i = 0; i < collections.length; i++)
            {
                // is the ID a handle?
                if (collections[i].indexOf('/') != -1)
                {
                    // string has a / so it must be a handle - try and resolve
                    // it
                    mycollections[i] = (Collection) HandleManager
                            .resolveToObject(c, collections[i]);

                    // resolved, now make sure it's a collection
                    if ((mycollections[i] == null)
                            || (mycollections[i].getType() != Constants.COLLECTION))
                    {
                        mycollections[i] = null;
                    }
                }
                // not a handle, try and treat it as an integer collection
                // database ID
                else if (collections[i] != null)
                {
                    mycollections[i] = Collection.find(c, Integer.parseInt(collections[i]));
                }

                // was the collection valid?
                if (mycollections[i] == null)
                {
                    throw new IllegalArgumentException("Cannot resolve "
                            + collections[i] + " to collection");
                }

                // print progress info
                String owningPrefix = "";

                if (i == 0)
                {
                    owningPrefix = "Owning ";
                }

                System.out.println(owningPrefix + " Collection: "
                        + mycollections[i].getMetadata("name"));
            }
            // end of validating collections

            try
            {
                c.setIgnoreAuthorization(true);

                if (command.equals("fix"))
                {
                    mycleaner.fixItems(c, mycollections, mapfile);
                }

                // complete all transactions
                c.complete();
            }
            catch (Exception e)
            {
                // abort all operations
                if (mapOut != null)
                {
                    mapOut.close();
                }

                mapOut = null;

                c.abort();
                e.printStackTrace();
                System.out.println(e);
                status = 1;
            }

            if (mapOut != null)
            {
                mapOut.close();
            }

            if (isTest)
            {
                System.out.println("***End of Test Run***");
            }
            System.exit(status);
        }

        private void fixItems(Context c, Collection[] mycollections, String mapFile)
                throws Exception
        {

            System.out.println("Generating mapfile: " + mapFile);

            // create the mapfile
            File outFile = null;

            if (!isTest)
            {
              // sneaky isResume == true means open file in append mode
                outFile = new File(mapFile);
                mapOut = new PrintWriter(new FileWriter(outFile, isResume));

                if (mapOut == null)
                {
                    throw new Exception("can't open mapfile: " + mapFile);
                }
            }


            String mapOutput = null;
            // go through all collections
            for (int i = 0; i < mycollections.length; i++)
            {
                // get all items from the collection and fix them one by one
                ItemIterator iterator = mycollections[i].getAllItems();
                while (iterator.hasNext())
                 {
                    Item item = iterator.next();
                    mapOutput = mapOutput + item.getHandle();
                    // remove the timestamp from dc.date.issued

                     /**
                      * Fix the dc.date.
                      */
                    System.out.println("** Processing Item: " + item.getHandle());

                    // fix it only when the field's length is greater than 10
                    DCValue[] dcvalue = item.getMetadata("dc","date", "issued", Item.ANY);
                    if(dcvalue != null && dcvalue.length != 0){
                        //System.out.println("This is a testing - " + dcvalue.length );
                        String dateIssued = dcvalue[0].value;
                        if (dateIssued.length() > 10){

                            String dateIssuedFix = dateIssued.substring(0, 10);
                            if(!isTest){
                                item.clearMetadata("dc", "date", "issued", Item.ANY);
                                item.addMetadata("dc", "date", "issued", "en_US", dateIssuedFix);
                                System.out.println("dc.type: " + dateIssued + " => " + dateIssuedFix);
                            }
                            // log it
                            mapOutput = mapOutput + "|" + dateIssued + "=>" + dateIssuedFix;
                        }else{
                           // item.clearMetadata("dc", "date", "issued", Item.ANY);
                           // item.addMetadata("dc", "date", "issued", "en_US", dateIssued);
                            // log it too
                            mapOutput = mapOutput + "|" + dateIssued + "=>" + dateIssued;
                        }
                    }

                    // Check if we got dc.description there

                    if(item.getMetadata("dc", "description", null, Item.ANY)!= null && item.getMetadata("dc", "description", null, Item.ANY).length !=0){
                        //if(item.getMetadata("dc","description", null, Item.ANY) != null){
                        // remove dc.description? keep it there so far
                        // TODO

                        /**
                         * fix dc.type with dc.description
                          */

                       // should I remove dc.description or leave it as it is?
                       DCValue[] dctype = item.getMetadata("dc","type", null, Item.ANY);
                       String type = null;
                       if(dctype != null && dctype.length != 0){
                           type = dctype[0].value;
                           // remove it?? or untouch it ??
                           // item.clearMetadata("dc", "type", null, Item.ANY);

                       }
                        DCValue[] dcdec = item.getMetadata("dc","description", null, Item.ANY);
                        String description;
                        if(dcdec != null && dcdec.length != 0)
                        {
                            description = dcdec[0].value;

                            if(!isTest){
                                // at least remove dc.type
                                item.clearMetadata("dc", "type", null, Item.ANY);
                                // put it into dc.type
                                item.addMetadata("dc", "type", null, "en_US", description);
                                System.out.println("dc.type: " + type + " => " + description);
                            }

                            // log it
                            mapOutput = mapOutput + "|" + type + "=>" + description;
                        }
                       
                        //}

                        /**
                         * Fix the Conference Name
                         */

                        // fix conference name, if it is a conference paper, copy the journal title to conference title
                        // and remove the journal title
                        if(item.getMetadata("dc", "description", null, Item.ANY)[0].value.equalsIgnoreCase("Conference Paper")){
                            if(item.getMetadata("dc","citation", "journalTitle", Item.ANY) != null){
                                // remove dc.citation.journalTitle
                                // TODO
                                DCValue[] jt = item.getMetadata("dc", "citation", "journalTitle", Item.ANY);
                                String confname;
                                if(jt != null && jt.length != 0)
                                {
                                    confname = jt[0].value;

                                    if(!isTest){
                                        // at least remove dc.type
                                        item.clearMetadata("dc", "citation", "conferenceName", Item.ANY);
                                        // put it into dc.type
                                        item.addMetadata("dc", "citation", "conferenceName", "en_US", confname);
                                        System.out.println("dc.citation.conferenceName: => " + confname);
                                        //TODO item.clearMetadata("dc", "citation", "journalTitle", Item.ANY);
                                    }

                                    // log it
                                    mapOutput = mapOutput + " =>" + confname;
                                }

                            }

                            /**
                             *
                             * Fix the Conference Date
                             *
                             */

                            // fix conference date, if it is a conference paper, copy the date.issued to date.submitted
                            // still keep date.submitted, copy date.submitted to dc.date.note
                            if(item.getMetadata("dc","date", "issued", Item.ANY) != null){
                                // TODO
                                DCValue[] issuedate = item.getMetadata("dc","date", "issued", Item.ANY);
                                DCValue[] submitdate = item.getMetadata("dc","date", "submitted", Item.ANY);
                                String confdate;
                                if(issuedate != null && issuedate.length != 0)
                                {
                                    confdate = issuedate[0].value;

                                    if(!isTest){
                                        if(item.getMetadata("dc","date", "note", Item.ANY) != null && item.getMetadata("dc","date", "note", Item.ANY).length != 0){
                                            System.out.println("dc.date.note is not empty, no copy over!!! ");
                                        }else{
                                            if(submitdate != null && submitdate.length !=0){
                                                // this is a temporary for date.submitted in the database, we may remove it later if we don't want to keep it
                                                item.clearMetadata("dc", "date", "note", Item.ANY);
                                                item.addMetadata("dc", "date", "note", "en_US", submitdate[0].value);
                                                System.out.println("dc.date.note: => " + confdate);
                                            }
                                            // at least remove dc.date.submitted
                                            item.clearMetadata("dc", "date", "submitted", Item.ANY);
                                            // put it into dc.date.submitted
                                            item.addMetadata("dc", "date", "submitted", "en_US", confdate);
                                            System.out.println("dc.date.submitted: => " + confdate);
                                        }
                                    }

                                    // log it
                                    mapOutput = mapOutput + " =>" + confdate;
                                }

                            }
                        }
                    }
                     
                     /**
                      * Fix the dc.subject.keyword
                      */

                    // fix dc.subject, if it is a dc.subject.keyword is not null, copy the data to dc.subject
                    if(item.getMetadata("dc","subject", "keyword", Item.ANY) != null && item.getMetadata("dc","subject", "keyword", Item.ANY).length !=0){
                            // TODO
                        if(item.getMetadata("dc","subject", null, Item.ANY)!=null && item.getMetadata("dc","subject", null, Item.ANY).length !=0){

                            System.out.println("dc.subject is not empty, no copy over!!! ");

                        }else{
                            DCValue[] keyword = item.getMetadata("dc","subject", "keyword", Item.ANY);
                            String subject;
                            if(keyword != null && keyword.length != 0)
                            {
                                for(int sk=0; sk<keyword.length; sk++){
                                    subject = keyword[sk].value;

                                    if(!isTest){
                                        // put keyword into dc.subject
                                        item.addMetadata("dc", "subject", null, Item.ANY, subject);
                                        // clear dc.subject.keyword
                                        System.out.println("dc.subject: => " + subject);

                                    }

                                // log it
                                mapOutput = mapOutput + " =>" + subject;
                                // TODO item.clearMetadata("dc", "subject", "keyword", Item.ANY);
                            }

                        }
                    }

                }

                /**
                 * Fix the dc.contributor.entity to dc.description.sponsorship
                 */
                    if(item.getMetadata("dc","contributor", "entity", Item.ANY) != null && item.getMetadata("dc","contributor", "entity", Item.ANY).length !=0){
                             // TODO
                         if(item.getMetadata("dc","description", "sponsorship", Item.ANY)!=null && item.getMetadata("dc","description", "sponsorship", Item.ANY).length !=0){

                                 System.out.println("dc.description.sponsorship is not empty, no copy over!!! ");
                         }else{
                             DCValue[] sponsors = item.getMetadata("dc","contributor", "entity", Item.ANY);
                             String sponsor;
                             if(sponsors != null && sponsors.length != 0)
                             {
                                 for(int sk=0; sk<sponsors.length; sk++){
                                     sponsor = sponsors[sk].value;

                                     if(!isTest){
                                         // put contributor.entity to dc.description.sponsorship
                                         item.addMetadata("dc", "description", "sponsorship", Item.ANY, sponsor);
                                         System.out.println("dc.description.sponsorship: => " + sponsor);

                                     }

                                 // log it
                                 mapOutput = mapOutput + " =>" + sponsor;
                                 // clear out dc.contributor.entity
                                 item.clearMetadata("dc", "contributor", "entity", Item.ANY);
                             }

                         }
                     }
                }



                item.update();
                // prepare for next log line
                mapOutput = mapOutput + "\n";

                // made it this far, everything is fine, commit transaction
                if (mapOut != null)
                {
                    mapOut.println(mapOutput);
                }

                c.commit();

            }
        }
    }

}
