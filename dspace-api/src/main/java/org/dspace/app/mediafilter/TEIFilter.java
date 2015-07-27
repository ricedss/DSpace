/*
 * TEIFilter.java
 */

package org.dspace.app.mediafilter;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;

import org.jdom.Element;
import org.jdom.filter.ElementFilter;
import org.jdom.input.SAXBuilder;

/*
 *
 * to do: helpful error messages - can't find mediafilter.cfg - can't
 * instantiate filter - bitstream format doesn't exist
 *
 */
public class TEIFilter extends MediaFilter
{

    // These are the element names whose text will be extracted for indexing
    private final static Collection indexedElements = Arrays.asList(
            new String[] {"p", "hi", "figDesc", "titlePart", "docAuthor", "head"});

    public String getFilteredName(String oldFilename)
    {
        return oldFilename + ".txt";
    }

    /**
     * @return String bundle name
     *
     */
    public String getBundleName()
    {
        return "TEXT";
    }

    /**
     * @return String bitstreamformat
     */
    public String getFormatString()
    {
        return "Text";
    }

    /**
     * @return String description
     */
    public String getDescription()
    {
        return "Extracted text";
    }

    /**
     * @param source
     *            source input stream
     *
     * @return InputStream the resulting input stream
     */
    public InputStream getDestinationStream(InputStream source)
            throws Exception
    {
        StringBuilder output = new StringBuilder();

        // parse XML document
        SAXBuilder builder = new SAXBuilder();
        org.jdom.Document xmldoc = builder.build(source);
        String charsetName = "UTF-8"; // currently cannot ask JDOM doc what its encoding is

        // Find all elements whose name is in indexedElements.
        Iterator elements = xmldoc.getDescendants(new ElementFilter()
        {
            public boolean matches(Object o)
            {
                return super.matches(o)
                    && indexedElements.contains(((Element)o).getName());
            }
        });

        // Extract the content text from all found elements.
        // The content will appear out of order, but that doesn't matter.
        while (elements.hasNext())
        {
            Element e = (Element)elements.next();
            output.append(e.getText());
        }

        return new ByteArrayInputStream(output.toString().getBytes(charsetName));
    }
}
