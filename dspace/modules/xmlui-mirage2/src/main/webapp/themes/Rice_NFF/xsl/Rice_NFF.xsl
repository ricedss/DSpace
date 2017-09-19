<?xml version="1.0" encoding="UTF-8"?>

<!--
    
    Rice_Commencement.xsl
    
    For overrides in the "Rice University Commencement Programs and Ephemera" community to the base stylesheet (Rice.xsl).
    
    Authors: Ying Jin, Max Starkenburg

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


    <xsl:template name="simple-item-record-rows">
<!--                    <xsl:call-template name="itemSummaryView-DIM-URI"/-->
                    <xsl:call-template name="itemSummaryView-DIM-alternative-title"/>
                    <xsl:call-template name="itemSummaryView-DIM-authors"/>
                    <xsl:call-template name="itemSummaryView-DIM-translator"/>
                    <xsl:call-template name="itemSummaryView-DIM-date"/>
                    <xsl:call-template name="itemSummaryView-DIM-citation"/>
                    <xsl:call-template name="itemSummaryView-DIM-doi"/>
                    <xsl:call-template name="itemSummaryView-DIM-abstract"/>
                    <xsl:call-template name="itemSummaryView-DIM-description"/>
                    <xsl:call-template name="itemSummaryView-DIM-subject"/>
                    <xsl:if test="$ds_item_view_toggle_url != ''">
                        <xsl:call-template name="itemSummaryView-show-full"/>
                    </xsl:if>
                    <xsl:call-template name="itemSummaryView-collections"/>
  </xsl:template>



    <!-- Ying: Templates for required textarea attributes used if not found in DRI document -->
    <xsl:template name="textAreaCols">
      <xsl:attribute name="cols">80</xsl:attribute>
    </xsl:template>

    <xsl:template name="textAreaRows">
      <xsl:attribute name="rows">10</xsl:attribute>
    </xsl:template>

</xsl:stylesheet>
