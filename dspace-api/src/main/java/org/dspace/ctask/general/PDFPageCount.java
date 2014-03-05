/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.ctask.general;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.dspace.content.Bitstream;
import org.dspace.content.BitstreamFormat;
import org.dspace.content.Bundle;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.core.Utils;
import org.dspace.curate.AbstractCurationTask;
import org.dspace.curate.Curator;
import org.dspace.curate.Distributive;

import org.dspace.core.ConfigurationManager;
import org.elasticsearch.common.Base64;

import java.util.regex.MatchResult;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.InputStreamReader;
import org.dspace.authorize.AuthorizeException;




/**
 * PDFPageCount is a task that count the pages of a PDF file.
 *
 * @author Ying Jin
 */
@Distributive
public class PDFPageCount extends AbstractCurationTask
{
    // map of pdf to its page count
    private Map<String, String> countTable = new HashMap<String, String>();


    // command to get image from PDF; @FILE@, @OUTPUT@ are placeholders
    private static final String XPDF_PDFINFO_COMMAND[] =
    {
        "@COMMAND@", "-f", "1", "-l", "1", "@FILE@"
    };

    // executable path for "pdfinfo", comes from DSpace config at runtime.
    private String pdfinfoPath = null;

    // match line in pdfinfo output that describes file's Pages
    private static final Pattern PAGES_PATT = Pattern.compile("^Pages:\\s+(\\d+)");


    /**
     * Perform the curation task upon passed DSO
     *
     * @param dso the DSpace object
     * @throws IOException
     */
    @Override
    public int perform(DSpaceObject dso) throws IOException
    {
        countTable.clear();

        if (pdfinfoPath == null)
        {
            pdfinfoPath = ConfigurationManager.getProperty("xpdf.path.pdfinfo");
            if (pdfinfoPath == null)
            {
                throw new IllegalStateException("No value for key \"xpdf.path.pdfinfo\" in DSpace configuration!  Should be path to XPDF pdfinfo executable.");
            }
        }

        distribute(dso);
        countResults();
        return Curator.CURATE_SUCCESS;
    }
    
    @Override
    protected void performItem(Item item) throws SQLException, IOException
    {
        for (Bundle bundle : item.getBundles())
        {
            for (Bitstream bs : bundle.getBitstreams())
            {
                // check if the bitstream is the PDF
                String bsformat = bs.getFormat().getMIMEType();

                //String pc = bs.getFormat().getMIMEType();
                String pagecount = "";

                if(bsformat.equals("application/pdf")){
                    try{
                        pagecount = pageCount(bs.retrieve());
                    }catch (IOException ioe){
                        throw new IOException(ioe.getMessage(), ioe);
                    }catch (SQLException sqlE){
                        throw new SQLException(sqlE.getMessage(), sqlE);
                    }catch (AuthorizeException athE){

                    }catch (Exception ex){

                    }
                    countTable.put(item.getHandle() + ", " + bs.getName(), pagecount);
                }


            }
        }
    }
    
    private void countResults() throws IOException
    {
        try
        {
            Context c = new Context();
            StringBuilder sb = new StringBuilder();
            for (String pc : countTable.keySet())
            {
                //System.out.println(pc + "\n");
                //System.out.println(countTable.get(pc) + "\n");
                sb.append(String.format("%s", pc)).append(":").
                append(String.format("%s", countTable.get(pc))). // Ying added this total size
                append("\n | ");
            }
            report(sb.toString());
            setResult(sb.toString());
            c.complete();
        }
        catch (SQLException sqlE)
        {
            throw new IOException(sqlE.getMessage(), sqlE);
        }
    }

    private String pageCount(InputStream sourceStream)
        throws Exception
    {
    // sanity check: xpdf paths are required. can cache since it won't change

    File sourceTmp = File.createTempFile("DSfilt",".pdf");
    sourceTmp.deleteOnExit();
    int status = 0;
    try
    {
        OutputStream sto = new FileOutputStream(sourceTmp);
        Utils.copy(sourceStream, sto);
        sto.close();
        sourceStream.close();

        String pdfinfoCmd[] = XPDF_PDFINFO_COMMAND.clone();
        pdfinfoCmd[0] = pdfinfoPath;
        pdfinfoCmd[pdfinfoCmd.length-1] = sourceTmp.toString();
        BufferedReader lr = null;
        try
        {
            MatchResult pages = null;  // Ying added this for pdf page counts

            Process pdfProc = Runtime.getRuntime().exec(pdfinfoCmd);
            lr = new BufferedReader(new InputStreamReader(pdfProc.getInputStream()));
            String line;
            for (line = lr.readLine(); line != null; line = lr.readLine())
            {
                Matcher pp = PAGES_PATT.matcher(line);
                if (pp.matches())
                {
                    pages = pp.toMatchResult();
                }
            }
            int istatus = pdfProc.waitFor();
            if (istatus != 0)
            {
               // log.error("XPDF pdfinfo proc failed, exit status=" + istatus + ", file=" + sourceTmp);
            }
            else{
                return pages.group(1);

            }
        }catch(Exception ex) {
           throw new Exception(ex.getMessage(), ex);
        }

        finally
        {
            if (lr != null)
            {
                lr.close();
            }
        }
    }finally
        {
            if (!sourceTmp.delete())
            {
                //log.error("Unable to delete temporary source");
            }

            if (status != 0)
            {
                //log.error("PDF conversion proc failed, exit status=" + status + ", file=" + sourceTmp);
            }
        }


      return "0";
    }
}
