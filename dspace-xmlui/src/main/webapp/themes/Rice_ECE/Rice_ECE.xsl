<?xml version="1.0" encoding="UTF-8"?>

<!--

    Rice_ECE.xsl

    This file pulls in the Rice look-and-feel while overriding certain templates as noted in comments below.

    Authors: Sid Byrd, Ying Jin, Max Starkenburg

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

    <!-- MMS: COinS change.  Ying (via MMS): Instead of author/publisher info, display full citation.  -->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM">
        <xsl:variable name="itemWithdrawn" select="@withdrawn" />
        <div class="artifact-description">
            <div class="artifact-title">
                <!-- MMS: Moved the COinS span outside of the <a> so that the "title" tooltip text doesn't show up when hovering over the title link. -->
                <xsl:call-template name="COinS" />
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="$itemWithdrawn">
                                <xsl:value-of select="ancestor::mets:METS/@OBJEDIT" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="ancestor::mets:METS/@OBJID" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='title']">
                            <xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </div>
            <!-- Ying (via MMS): Instead of displaying the author and publisher information, display a full citation. -->
            <xsl:if test="dim:field[@element='identifier'][@qualifier='citation']">
                <div class="artifact-common">
                    <xsl:copy>
                        <xsl:call-template name="parse">
                            <xsl:with-param name="str" select="dim:field[@element='identifier'][@qualifier='citation'][1]/node()"/>
                            <xsl:with-param name="omit-link">1</xsl:with-param>
                        </xsl:call-template>
                    </xsl:copy>
                </div>
            </xsl:if>
        </div>
    </xsl:template>


    <!-- Ying (via MMS): Overriding from reusable-overrides.xsl to add the "Type", "Keywords", "Publisher", "Center" rows, 
         suppress the "Description" and "URI" rows, and customize the "Date" row. -->
    <xsl:template name="simple-item-record-rows">
        <xsl:apply-templates select="." mode="title"/>
        <xsl:apply-templates select="." mode="alternative-title"/>
        <xsl:apply-templates select="." mode="author"/>
        <xsl:apply-templates select="." mode="translator"/>
        <xsl:apply-templates select="." mode="type"/>
        <xsl:apply-templates select="." mode="keywords"/>
        <xsl:apply-templates select="." mode="publisher"/>
        <xsl:apply-templates select="." mode="citation"/>
        <!-- Ying (via MMS): Department would go here -->
        <xsl:apply-templates select="." mode="center"/>
        <xsl:apply-templates select="." mode="abstract"/>
        <!-- Ying (via MMS): Don't output the "Description" row. -->
        <!-- MMS: Don't output the "URI" row since that information is already in the "Citation". -->
        <xsl:apply-templates select="." mode="date"/>
    </xsl:template>
    <!-- Ying (via MMS): 'Type' row in simple item record -->
    <xsl:template match="dim:dim" mode="type">
        <xsl:if test="dim:field[@element='type' and not(@qualifier)]/child::node()">
            <tr>
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-type</i18n:text>:</span></th>
                <td><xsl:copy-of select="dim:field[@element='type' and not(@qualifier)]/child::node()"/></td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- Ying (via MMS): 'Keywords' row in simple item record -->
    <xsl:template match="dim:dim" mode="keywords">
        <xsl:if test="dim:field[@element='subject' and @qualifier='keyword']">
            <tr>
                <th><span class="bold"><i18n:text>xmlui.Rice_ECE.Keywords</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='subject' and @qualifier='keyword']">
                        <xsl:value-of select="."/>
                        <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='keyword']) != 0">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- Ying (via MMS): 'Publisher' row in simple item record -->
    <xsl:template match="dim:dim" mode="publisher">
        <xsl:if test="dim:field[@element='publisher' and not(@qualifier)]">
            <tr>
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-publisher</i18n:text>:</span></th>
                <td>
                    <xsl:copy>
                        <xsl:call-template name="parse">
                            <xsl:with-param name="str" select="dim:field[@element='publisher' and not(@qualifier)][1]/node()"/>
                        </xsl:call-template>
                    </xsl:copy>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- Ying (via MMS): 'Center' (and DSP subcategories) row in simple item record -->
    <xsl:template match="dim:dim" mode="center">
        <xsl:if test="dim:field[@element='description' and @qualifier='center']">
            <xsl:variable name="dim" select="."/>
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.Rice_ECE.Center</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='description' and @qualifier='center']">
                        <xsl:variable name="center" select="."></xsl:variable>
                        <xsl:choose>
                            <xsl:when test="contains($center, '(')">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="substring-before(substring-after($center, ' ('), ')')"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="substring-before($center, ' (')"/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- Ying (via MMS): if Center==DSP, include DSP subcategory -->
                        <xsl:if test="contains($center, 'DSP') and $dim/dim:field[@element='subject' and @qualifier='other']">
                            <xsl:text> (</xsl:text>
                            <!-- i18n: Subcategory: -->
                            <i18n:text>xmlui.Rice_ECE.Subcategory</i18n:text>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="$dim/dim:field[@element='subject' and @qualifier='other']">
                                <xsl:copy-of select="."/>
                                <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='other']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='center']) != 0">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- Ying (via MMS): 'Date' row in simple item record (uses "Date Published" instead of just "Date" and doesn't allow for multiple dates to be displayed) -->
    <xsl:template match="dim:dim" mode="date">
        <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.Rice.DatePublished</i18n:text>:</span></th>
                <td>
                    <xsl:call-template name="displayDate">
                        <xsl:with-param name="iso" select="dim:field[@element='date' and @qualifier='issued']/child::node()"/>
                    </xsl:call-template>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    
    <!-- Ying (via MMS): Make textareas larger for easier editing. -->
    <xsl:template name="textAreaCols">
      <xsl:attribute name="cols">80</xsl:attribute>
    </xsl:template>
    <xsl:template name="textAreaRows">
      <xsl:attribute name="rows">10</xsl:attribute>
    </xsl:template>


</xsl:stylesheet>
