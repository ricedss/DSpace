<?xml version="1.0" encoding="UTF-8"?>

<!-- 

    Rice_ETD.xsl

    This file contains overrides of templates, as commented below, for the 
    "Rice University Electronic Theses and Dissertations" community of the 
    Rice Digital Scholarship archive.
    
-->    

<xsl:stylesheet 
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:import href="../Rice/Rice.xsl"/>
    <xsl:output indent="yes"/>

    <!-- Ying (via MMS): Overriding from reusable-overrides.xsl to 
         add the "Advisor" and "Degree" rows, 
         prevent "Advisor" from showing up in the "Author" row, and 
         suppress the "Citation" row. -->
    <xsl:template name="simple-item-record-rows">
        <xsl:apply-templates select="." mode="title"/>
        <xsl:apply-templates select="." mode="alternative-title"/>
        <xsl:apply-templates select="." mode="author"/>
        <xsl:apply-templates select="." mode="translator"/>
        <xsl:apply-templates select="." mode="advisor"/>
        <xsl:apply-templates select="." mode="degree"/>
        <xsl:apply-templates select="." mode="abstract"/>
        <xsl:apply-templates select="." mode="description"/>
        <!-- Ying: add the "Citation" row. -->
        <xsl:apply-templates select="." mode="citation"/>
        <xsl:apply-templates select="." mode="uri"/>
        <xsl:apply-templates select="." mode="date"/>
    </xsl:template>
    <!-- MMS: 'Author' row in simple item record (don't let this catch the 'Advisor' information) -->
    <xsl:template match="dim:dim" mode="author">
        <xsl:if test="dim:field[@element='creator'] or dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator') and not(@qualifier='advisor')]">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></th>
                <td>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <span>
                                    <xsl:if test="@authority">
                                        <xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
                                    </xsl:if>
                                    <xsl:copy-of select="node()"/>
                                </span>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='creator']">
                            <xsl:for-each select="dim:field[@element='creator']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- MMS: Don't let dc.contributor.funder or .translator count as an author. -->
                        <xsl:when test="dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator') and not(@qualifier='advisor')]">
                            <xsl:for-each select="dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator') and not(@qualifier='advisor')]">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator') and not(@qualifier='advisor')]) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- Ying (via MMS): 'Advisor' row in simple item record -->
    <xsl:template match="dim:dim" mode="advisor">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='advisor']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-advisor</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='contributor'][@qualifier='advisor']">
                        <xsl:copy-of select="node()"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='advisor']) != 0">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- Ying (via MMS): 'Degree' row in simple item record -->
    <xsl:template match="dim:dim" mode="degree">
        <xsl:if test="dim:field[@element='degree'][@qualifier='name']">
            <tr class="ds-table-row">
                <!-- i18n: Degree -->
                <th><span class="bold"><i18n:text>xmlui.Rice_ETD.Degree</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='degree' and @qualifier='name']">
                        <xsl:copy-of select="./node()"/>
                        <xsl:text> thesis</xsl:text>
                        <xsl:if test="count(following-sibling::dim:field[@element='degree' and @qualifier='name']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    

</xsl:stylesheet>
