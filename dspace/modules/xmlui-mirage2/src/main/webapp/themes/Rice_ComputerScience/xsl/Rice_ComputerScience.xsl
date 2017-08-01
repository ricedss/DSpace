<?xml version="1.0" encoding="UTF-8"?>

<!--

    Rice_ComputerScience.xsl

    This file pulls in the Rice look-and-feel while overriding certain templates as noted in comments below.

    Authors: Ying Jin

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


    <!-- Ying: Updated this for our new theme -->
    <xsl:template name="simple-item-record-rows">

                     <xsl:call-template name="itemSummaryView-DIM-alternative-title"/>
                        <xsl:call-template name="itemSummaryView-DIM-authors"/>
                        <xsl:call-template name="itemSummaryView-DIM-architect"/>
                        <xsl:call-template name="itemSummaryView-DIM-illustrator"/>
                        <xsl:call-template name="itemSummaryView-DIM-photographer"/>
                        <xsl:call-template name="itemSummaryView-DIM-performer"/>
                        <xsl:call-template name="itemSummaryView-DIM-translator"/>
                        <xsl:call-template name="itemSummaryView-DIM-date"/>
                        <xsl:call-template name="itemSummaryView-DIM-description"/>
                        <xsl:call-template name="itemSummaryView-DIM-citation"/>
                        <xsl:call-template name="itemSummaryView-DIM-doi"/>
                        <xsl:call-template name="itemSummaryView-DIM-abstract"/>
                        <xsl:call-template name="itemSummaryView-DIM-subject"/>
                        <xsl:call-template name="itemSummaryView-DIM-type"/>
                        <xsl:call-template name="itemSummaryView-DIM-publisher"/>
                        <xsl:call-template name="itemSummaryView-DIM-department"/>
                        <xsl:call-template name="itemSummaryView-DIM-digitalidentifier"/>
			<xsl:call-template name="itemSummaryView-DIM-rights"/>
                        <xsl:call-template name="itemSummaryView-DIM-URI"/>
                        <xsl:if test="$ds_item_view_toggle_url != ''">
                            <xsl:call-template name="itemSummaryView-show-full"/>
                        </xsl:if>
                        <xsl:call-template name="itemSummaryView-collections"/>

      </xsl:template>

   <xsl:template name="itemSummaryView-DIM-digitalidentifier">
        <xsl:if test="dim:field[@element='digital'][@qualifier='identifier' and descendant::text()]">
            <div class="simple-item-view-digitalidentifier item-page-field-wrapper table">
                <h5><i18n:text>xmlui.Rice.digitalidentifier</i18n:text></h5>
                        <xsl:for-each select="dim:field[@element='digital'][@qualifier='identifier']">
                            <div>

                                <xsl:copy-of select="node()"/>
                            </div>
                        </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
