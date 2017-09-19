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

    <!-- Ying: Updated this for our new theme -->
    <xsl:template name="simple-item-record-rows">
  <!--                    <xsl:call-template name="itemSummaryView-DIM-URI"/-->
                      <xsl:call-template name="itemSummaryView-DIM-alternative-title"/>
                      <xsl:call-template name="itemSummaryView-DIM-authors"/>
                      <xsl:call-template name="itemSummaryView-DIM-translator"/>
                      <xsl:call-template name="itemSummaryView-DIM-type"/>
                      <xsl:call-template name="itemSummaryView-DIM-subject-keyword"/>
                      <xsl:call-template name="itemSummaryView-DIM-publisher"/>
                      <xsl:call-template name="itemSummaryView-DIM-citation"/>
                      <xsl:call-template name="itemSummaryView-DIM-description-center"/>
                      <xsl:call-template name="itemSummaryView-DIM-abstract"/>
                      <xsl:call-template name="itemSummaryView-DIM-date"/>
                      <xsl:if test="$ds_item_view_toggle_url != ''">
                          <xsl:call-template name="itemSummaryView-show-full"/>
                      </xsl:if>
                      <xsl:call-template name="itemSummaryView-collections"/>
      </xsl:template>

    <xsl:template name="textAreaCols">
      <xsl:attribute name="cols">80</xsl:attribute>
    </xsl:template>
    <xsl:template name="textAreaRows">
      <xsl:attribute name="rows">10</xsl:attribute>
    </xsl:template>


</xsl:stylesheet>
