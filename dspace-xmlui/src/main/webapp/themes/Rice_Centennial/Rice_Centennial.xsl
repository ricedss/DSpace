<?xml version="1.0" encoding="UTF-8"?>

<!--

    Rice_Centennial.xsl

    Stylesheet for customizations of the following collections: "History of Rice University", 
    "Rice University General Announcements", and "Rice University Presidential Inauguration Speeches".

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


    <!-- Simple item record metadata table overridden from reusable-overrides.xsl in order to:
         customize the "Title" and "Date" rows, add a "Publisher" row, and suppress the "Citation" row.
    -->
    <xsl:template name="simple-item-record-rows">
        <xsl:apply-templates select="." mode="title-subtitle"/>
        <xsl:apply-templates select="." mode="alternative-title"/>
        <xsl:apply-templates select="." mode="author"/>
        <xsl:apply-templates select="." mode="translator"/>
        <xsl:apply-templates select="." mode="publisher"/>
        <xsl:apply-templates select="." mode="abstract"/>
        <xsl:apply-templates select="." mode="description"/>
        <xsl:apply-templates select="." mode="uri"/>
        <xsl:apply-templates select="." mode="date"/>
    </xsl:template>
    <!-- 'Title' row in simple item record (tack on any subtitle to the main title after a semi-colon) -->
    <xsl:template match="dim:dim" mode="title-subtitle">
        <tr class="ds-table-row">
            <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>:</span></th>
            <td>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='title' and not(@qualifier='subtitle')]">
                        <xsl:copy>
                            <xsl:call-template name="parse">
                                <xsl:with-param name="str" select="dim:field[@element='title'][1]/child::node()"/>
                            </xsl:call-template>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="untitled"><i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text></span>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="dim:field[@element='title' and @qualifier='subtitle']">
                    <xsl:text>; </xsl:text>
                    <xsl:copy>
                        <xsl:call-template name="parse">
                            <xsl:with-param name="str" select="dim:field[@element='title' and @qualifier='subtitle'][1]/child::node()"/>
                        </xsl:call-template>
                    </xsl:copy>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>    
    <!-- 'Publisher' row in simple item record -->
    <xsl:template match="dim:dim" mode="publisher">
        <xsl:if test="dim:field[@element='publisher' and not(@qualifier)]">
            <tr class="ds-table-row even">
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
    <!-- 'Date' row in simple item record (uses "Date Published" instead of just "Date" and doesn't allow for multiple dates to be displayed) -->
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



</xsl:stylesheet>
