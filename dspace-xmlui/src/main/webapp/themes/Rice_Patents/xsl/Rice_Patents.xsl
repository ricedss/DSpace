<?xml version="1.0" encoding="UTF-8"?>

<!--

    Rice_Earth.xsl

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


    <!-- Ying: Updated this for our new theme -->
    <xsl:template name="simple-item-record-rows">
  <!--                    <xsl:call-template name="itemSummaryView-DIM-URI"/-->
                      <xsl:call-template name="itemSummaryView-DIM-inventor"/>
                      <!--xsl:call-template name="itemSummaryView-DIM-title"/-->
                      <xsl:call-template name="itemSummaryView-DIM-abstract"/>
                      <xsl:call-template name="itemSummaryView-DIM-format-extent"/>
                      <xsl:call-template name="itemSummaryView-DIM-citation"/>
                      <xsl:if test="$ds_item_view_toggle_url != ''">
                          <xsl:call-template name="itemSummaryView-show-full"/>
                      </xsl:if>
                      <xsl:call-template name="itemSummaryView-collections"/>
      </xsl:template>

</xsl:stylesheet>
