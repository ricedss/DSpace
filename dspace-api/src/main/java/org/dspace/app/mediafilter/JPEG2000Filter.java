
/*
 * JPEGFilter.java
 *
 * Version: $Revision: 1269 $
 *
 * Date: $Date: 2005-07-29 10:56:10 -0500 (Fri, 29 Jul 2005) $
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
/*
 * Copyright (c) 2008  Los Alamos National Security, LLC.
 *
 * Los Alamos National Laboratory
 * Research Library
 * Digital Library Research & Prototyping Team
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 *
 */

/**
 * Ying Jin, 2009-06-18
 * Modified the code from djatoka package - DjatokaExtractProcessor.java
 */
package org.dspace.app.mediafilter;

import java.awt.image.BufferedImage;


import gov.lanl.adore.djatoka.io.FormatFactory;
import gov.lanl.adore.djatoka.io.IWriter;
import gov.lanl.adore.djatoka.util.ImageProcessingUtils;
import gov.lanl.adore.djatoka.IExtract;
import gov.lanl.adore.djatoka.DjatokaException;
import gov.lanl.adore.djatoka.DjatokaDecodeParam;
import gov.lanl.adore.djatoka.kdu.KduExtractExe;

import java.io.*;

import org.dspace.core.ConfigurationManager;

/**
 * Filter jpeg2000 image bitstreams, scaling the image to be within the bounds of
 * thumbnail.maxwidth, thumbnail.maxheight, the size we want our thumbnail to be
 * no bigger than. Creates only JPEGs.
 */
public class JPEG2000Filter extends MediaFilter
{

    private static FormatFactory fmtFactory = new FormatFactory();

    /**
     * Sets the format factory used to serialize extracted region
     * @param ff the format factory used to serialize extracted region
     * @throws DjatokaException
     */
    public void setFormatFactory(FormatFactory ff) throws DjatokaException {
        fmtFactory = ff;
    }
    
    public String getFilteredName(String oldFilename)
    {
        return oldFilename + ".jpg";
    }

    /**
     * @return String bundle name
     *
     */
    public String getBundleName()
    {
        return "THUMBNAIL";
    }

    /**
     * @return String bitstreamformat
     */
    public String getFormatString()
    {
        return "JPEG";
    }

    /**
     * @return String description
     */
    public String getDescription()
    {
        return "Generated Thumbnail";
    }

    /**
     * @param source
     *            source input stream
     *
     * @return InputStream the resulting input stream
     */
    public InputStream getDestinationStream(InputStream source){
        return null;
    }

    public InputStream getDestinationStream(String filename, String source, int ID)
        throws Exception
    {

        float xmax = (float) ConfigurationManager
                .getIntProperty("thumbnail.maxwidth");
        float ymax = (float) ConfigurationManager
                .getIntProperty("thumbnail.maxheight");


        int[] sd = {(int)xmax, (int)ymax};

        //System.out.print("OUTPUT from JP2000 thumbnail.... xmax=" + xmax + ", ymax = " + ymax);

        // from djatoka
        IExtract ex = new KduExtractExe();
        IWriter w = fmtFactory.getWriter("image/jpeg");
        DjatokaDecodeParam params = new DjatokaDecodeParam();

        params.setScalingDimensions(sd);
        //params.setScalingFactor(1);
        //BufferedImage buf = ex.process(source, params);
//        String file = "/Users/yj4/projects/djatoka/48color600dpi.jp2";
        BufferedImage buf = ex.process(filename, params);

        BufferedImage thumbnail = applyScaling(buf, params);
        /**
         * testing
         */
        //BufferedOutputStream os = new BufferedOutputStream(new FileOutputStream(new File("/Users/yj4/projects/djatoka/testquatity.jpg")));
		//w.write(thumbnail, os);
		//os.close();
        /**
         * end testing
         */


        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        w.write(thumbnail, baos);
/*        if (bi != null) {
            if (params.getScalingFactor() != 1.0 || params.getScalingDimensions() != null)
                bi = applyScaling(bi, params);
            if (params.getTransform() != null)
                bi = params.getTransform().run(bi);
            w.write(bi, os);
        }
*/
        // END from djatoka

        // read in bitstream's image
        //BufferedImage buf = ImageIO.read(source);

        // get config params
        // now get the image dimensions
 /*       float xsize = (float) buf.getWidth(null);
        float ysize = (float) buf.getHeight(null);

        // if verbose flag is set, print out dimensions
        // to STDOUT
        if (MediaFilterManager.isVerbose)
        {
            System.out.println("original size: " + xsize + "," + ysize);
        }

        // scale by x first if needed
        if (xsize > xmax)
        {
            // calculate scaling factor so that xsize * scale = new size (max)
            float scale_factor = xmax / xsize;

            // if verbose flag is set, print out extracted text
            // to STDOUT
            if (MediaFilterManager.isVerbose)
            {
                System.out.println("x scale factor: " + scale_factor);
            }

            // now reduce x size
            // and y size
            xsize = xsize * scale_factor;
            ysize = ysize * scale_factor;

            // if verbose flag is set, print out extracted text
            // to STDOUT
            if (MediaFilterManager.isVerbose)
            {
                System.out.println("new size: " + xsize + "," + ysize);
            }
        }

        // scale by y if needed
        if (ysize > ymax)
        {
            float scale_factor = ymax / ysize;

            // now reduce x size
            // and y size
            xsize = xsize * scale_factor;
            ysize = ysize * scale_factor;
        }

        // if verbose flag is set, print details to STDOUT
        if (MediaFilterManager.isVerbose)
        {
            System.out.println("created thumbnail size: " + xsize + ", "
                    + ysize);
        }
*/
/*
        // create an image buffer for the thumbnail with the new xsize, ysize
        BufferedImage thumbnail = new BufferedImage((int) xsize, (int) ysize,
                BufferedImage.TYPE_INT_RGB);

        // now render the image into the thumbnail buffer
        Graphics2D g2d = thumbnail.createGraphics();
        g2d.drawImage(buf, 0, 0, (int) xsize, (int) ysize, null);
*/
        // now create an input stream for the thumbnail buffer and return it

        //ImageIO.write(thumbnail, "jpeg", baos);

        // now get the array
        ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());

        return bais; // hope this gets written out before its garbage collected!
    }


        /**
         * Apply scaling, if Scaling Factor != to 1.0 then check ScalingDimensions
         * for w,h vars.  A scaling factor value must be greater than 0 and less than 2.
         * Note that ScalingFactor overrides ScalingDimensions.
         * @param bi BufferedImage to be scaled.
         * @param params DjatokaDecodeParam containing ScalingFactor or ScalingDimensions vars
         * @return scaled instance of provided BufferedImage
         */
        private static BufferedImage applyScaling(BufferedImage bi, DjatokaDecodeParam params) {
            if (params.getScalingFactor() != 1.0
                    && params.getScalingFactor() > 0
                    && params.getScalingFactor() < 3)
                bi = ImageProcessingUtils.scale(bi,params.getScalingFactor());
            else if (params.getScalingDimensions() != null
                    && params.getScalingDimensions().length == 2) {
                int width = params.getScalingDimensions()[0];
                if (width >= 3 * bi.getWidth())
                    return bi;
                int height = params.getScalingDimensions()[1];
                if (height >= 3 * bi.getHeight())
                    return bi;
                bi = ImageProcessingUtils.scale(bi, width, height);
            }
            return bi;
        }
    

}
