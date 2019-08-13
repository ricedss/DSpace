/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.mediafilter;

import org.dspace.content.Bitstream;
import org.dspace.content.Item;
import org.dspace.core.Context;
import java.io.InputStream;


/**
 * Abstract class which defines the default settings for a *simple* Media or Format Filter. 
 * This class may be extended by any class which wishes to define a simple filter to be run 
 * by the MediaFilterManager.  More complex filters should likely implement the FormatFilter
 * interface directly, so that they can define their own pre/postProcessing methods.
 */
public abstract class MediaFilter implements FormatFilter
{
	/**
     * Perform any pre-processing of the source bitstream *before* the actual 
     * filtering takes place in MediaFilterManager.processBitstream().
     * <p>
     * Return true if pre-processing is successful (or no pre-processing
     * is necessary).  Return false if bitstream should be skipped
     * for any reason.
     * 
     * 
     * @param c context
     * @param item item containing bitstream to process
     * @param source source bitstream to be processed
     * @param verbose verbose mode
     * 
     * @return true if bitstream processing should continue, 
     *          false if this bitstream should be skipped
     * @throws Exception if error
     */
    @Override
    public boolean preProcessBitstream(Context c, Item item, Bitstream source, boolean verbose)
            throws Exception
    {
        return true;  //default to no pre-processing
    }
     
    /**
     * Perform any post-processing of the generated bitstream *after* this
     * filter has already been run.
     * <p>
     * Return true if pre-processing is successful (or no pre-processing
     * is necessary).  Return false if bitstream should be skipped
     * for some reason.
     * 
     * 
     * @param c
     *            context
     * @param item
     *            item containing bitstream to process
     * @param generatedBitstream
     *            the bitstream which was generated by
     *            this filter.
     * @throws java.lang.Exception
     */
    @Override
    public void postProcessBitstream(Context c, Item item, Bitstream generatedBitstream)
            throws Exception
    {
        //default to no post-processing necessary
    }

    // Ying added this for JPEG2000
    /**
     *
     * @param bitstream to filter
     * @param verbose verbosity flag
     * @return null
     * @throws Exception
     */
    public InputStream getDestinationStream(Bitstream bitstream, boolean verbose)
            throws Exception
    {
        return null;
    }
    // END Ying added this for JPEG2000
}
