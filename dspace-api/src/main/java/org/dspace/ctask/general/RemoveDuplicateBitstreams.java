/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.ctask.general;

import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Bitstream;
import org.dspace.content.Bundle;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.curate.AbstractCurationTask;
import org.dspace.curate.Curator;
import org.dspace.curate.Mutative;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * A curation job to find derived bitstreams in the same item with the same sequence number and delete the older ones,
 * and also to find multiple derived thumbnails and extracted text for the same original file and delete the older ones.
 *
 * If you want it to actually *do* the deletes and not just report, you need to create
 * {config.dir}/modules/{taskname}.cfg and add the line "doDelete = true" inside it, where taskname is the
 * name you configured in curation.cfg for this task.
 *
 * @author Sid Byrd
 */
@Mutative
public class RemoveDuplicateBitstreams extends AbstractCurationTask
{

    // The log4j logger for this class
    private static Logger log = Logger.getLogger(RemoveDuplicateBitstreams.class);

    // Unless true, potential deletes will be reported but not actually performed.
    private boolean doDelete;
    // The results that we'll return
    private StringBuilder results;
    // Text for reporting what was done, that depends on doDelete.
    private String action;
    // Keeps all bitstreams from relevant bundles during processing.
    private List<Bitstream> bits;

    @Override
    public void init(Curator curator, String taskId) throws IOException
    {
        super.init(curator, taskId);
        doDelete = this.taskBooleanProperty("doDelete", false);
        action = (doDelete)? "Deleting" : "Would delete";
        results = new StringBuilder();
        bits = new ArrayList<>();
    }

    /**
     * Do one DSpace item.
     *
     * @param dso The DSpaceObject to be checked
     * @return The curation task status of the checking
     */
    @Override
    public int perform(DSpaceObject dso)
    {
        // Unless this is an item, we'll skip this item
        int status = Curator.CURATE_SKIP;
        logDebugMessage("The target dso is " + dso.getName());
        if (dso instanceof Item)
        {
            results.setLength(0);
            try {
                // Combine the bitstreams for all THUMBNAIL and TEXT bundles into one list.
                Item item = (Item)dso;
                bits.clear();
                for (Bundle bundle : item.getBundles())
                {
                    if ("THUMBNAIL".equals(bundle.getName()) || "TEXT".equals(bundle.getName()))
                    {
                        bits.addAll(Arrays.asList(bundle.getBitstreams()));
                    }
                }

                // Find and remove duplicate Bitstreams with the same sequence ID.
                boolean changed = findDupes(item, Comparator.comparingInt(Bitstream::getSequenceID));

                // Find and remove duplicate Bitstreams with the same name.
                changed |= findDupes(item, Comparator.comparing(Bitstream::getName));

                if (changed)
                {
                    if (doDelete)
                    {
                        item.update();
                    }
                    status = Curator.CURATE_SUCCESS;

                    String resultsStr = results.toString();
                    logDebugMessage("About to report: " + resultsStr);
                    setResult(resultsStr);
                    report(resultsStr);
                }

                item.decache();
            } catch (AuthorizeException | SQLException | IOException e) {
                // Something went wrong
                logDebugMessage(e.getMessage());
                status = Curator.CURATE_ERROR;
            }
        }

        return status;
    }

    /**
     * Debugging logging if required
     *
     * @param message The message to log
     */
    private void logDebugMessage(String message)
    {
        if (log.isDebugEnabled())
        {
            log.debug(message);
        }
    }

    /**
     * Check for duplicate values derived from bitstreams by sorting in order of those derived values, then
     * running through the sorted list and checking for the same value more than once in a row.
     * Algorithm was chosen so that the 99.9% case of no dupes should be cheap.
     * If any dupes are removed, they will be removed from this.bits as well.
     * @param item The Item that the Bitstreams in this.bits came from.
     * @param bitCompare A Comparator on Bitstreams such that if bitCompare.compare(b1, b2)==0, then
     *                   b1 and b2 are considered duplicates.
     * @return Whether any duplicates were deleted (or would have been deleted if doDelete).
     * @throws SQLException If traversing or removing a DSpace object failed due to DB.
     * @throws AuthorizeException If not authorized to remove a DSpace object.
     * @throws IOException If removing a DSpace object failed due to IO.
     */
    private boolean findDupes(Item item, Comparator<Bitstream> bitCompare)
            throws SQLException, AuthorizeException, IOException
    {
        // Sort on derived value
        bits.sort(bitCompare);

        // Run through the bitstreams looking for the value twice in a row.
        Bitstream prevB = null;
        int dupeStartI = -1;
        boolean inDupe = false;
        boolean changed = false;
        int listSize = bits.size();
        for (int i=0; i<listSize; i++)
        {
            Bitstream b = bits.get(i);
            if (prevB != null && bitCompare.compare(b, prevB) == 0) // There's more than one bitstream with this value!
            {
                if (!inDupe)
                {
                    dupeStartI = i-1;
                    inDupe = changed = true;
                }
            }
            else if (inDupe) // We just went past the last Bitstream from a dupe set.
            {
                int deletedCount = processDupes(bits.subList(dupeStartI, i), item.getHandle());
                i -= deletedCount;
                listSize -= deletedCount;
                inDupe = false;
            }
            prevB = b;
        }
        if (inDupe) // Leftover dupe from the last Bitstream encountered.
        {
            processDupes(bits.subList(dupeStartI, listSize), item.getHandle());
        }
        return changed;
    }

    /**
     * Deletes n-1 out of n indicated Bitstreams, keeping the one with the highest ID.
     * Deletes both from the given List and from DSpace.
     *
     * @param dupes The duplicates, all but one of which will be removed.
     * @param handle The handle of the item containing the dupes, for reporting.
     * @return The number of Bitstreams deleted (or that would have been deleted if doDelete) and removed from dupes.
     * @throws SQLException If traversing or removing a DSpace object failed due to DB.
     * @throws AuthorizeException If not authorized to remove a DSpace object.
     * @throws IOException If removing a DSpace object failed due to IO.
     */
    private int processDupes(List<Bitstream> dupes, String handle)
            throws SQLException, AuthorizeException, IOException
    {
        results.append(String.format("Processing %d dupes in item %s\n", dupes.size(), handle));
        int deletedCount = 0;

        // Sort in ID order, then delete all but the last.
        dupes.sort(Comparator.comparingInt(Bitstream::getID));
        ListIterator<Bitstream> it = dupes.listIterator();
        while (it.hasNext())
        {
            Bitstream b = it.next();

            // Delete Bitstream unless it's last, i.e. unless it has the highest ID of the dupes set.
            boolean delete = it.hasNext();

            // Report whether we're deleting or not.
            String currentAction = (delete) ? action : "Keeping";
            results.append(String.format("%s bitstream with id %d, seq %d, name %s\n", currentAction,
                    b.getID(), b.getSequenceID(), b.getName()));

            if (delete)
            {
                deletedCount++;

                // Remove from dupes list.
                it.remove();

                // Remove from DSpace.
                if (doDelete)
                {
                    for (Bundle bun : b.getBundles())
                    {
                        bun.removeBitstream(b);

                        // If the bitstream was the last one in the bundle, delete the bundle, too.
                        if (bun.getBitstreams().length == 0)
                        {
                            results.append(String.format("%s empty bundle with id %d, name %s\n", action,
                                    bun.getID(), bun.getName()));
                            for (Item item : bun.getItems())
                            {
                                item.removeBundle(bun);
                            }
                        }
                    }
                }
            }
        }
        return deletedCount;
    }
}


/*
As a bonus, here's a DSpace 5 SQL query to list bitstreams with duplicate sequence IDs:

select handle.handle, bit.sequence_id, bit.bitstream_id, mv.text_value as title
    from bitstream as bit
        join bundle2bitstream as b2b on b2b.bitstream_id=bit.bitstream_id
        join item2bundle as i2b on i2b.bundle_id=b2b.bundle_id
        inner join (
            select i2b.item_id, bit.sequence_id, count(*)
                from bitstream as bit
                    join bundle2bitstream as b2b on b2b.bitstream_id=bit.bitstream_id
                    join item2bundle as i2b on i2b.bundle_id=b2b.bundle_id
                group by i2b.item_id, bit.sequence_id
                having count(*) > 1
        ) as dup on i2b.item_id=dup.item_id and bit.sequence_id=dup.sequence_id
        join handle on handle.resource_id=i2b.item_id
        join metadatavalue as mv on mv.resource_id=bit.bitstream_id and mv.resource_type_id=0
        join metadatafieldregistry as mfr on mfr.element='title' and mfr.qualifier is null and mv.metadata_field_id=mfr.metadata_field_id
        join metadataschemaregistry as msr on msr.short_id='dc' and mfr.metadata_schema_id=msr.metadata_schema_id

 */