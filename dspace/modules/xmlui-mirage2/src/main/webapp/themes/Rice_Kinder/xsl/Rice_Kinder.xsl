<?xml version="1.0" encoding="UTF-8"?>

<!--

    Rice_Researchdata.xsl

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
          <xsl:call-template name="itemSummaryView-DIM-authors"/>
          <!--xsl:call-template name="itemSummaryView-DIM-title"/-->
        <xsl:call-template name="itemSummaryView-DIM-subject-keyword"/>
          <xsl:call-template name="itemSummaryView-DIM-abstract"/>
          <xsl:call-template name="itemSummaryView-DIM-description"/>
          <xsl:call-template name="itemSummaryView-DIM-citation"/>
          <xsl:call-template name="itemSummaryView-DIM-URI"/>
          <xsl:call-template name="itemSummaryView-DIM-relation-uri"/>
          <xsl:call-template name="itemSummaryView-DIM-rights"/>


          <xsl:if test="$ds_item_view_toggle_url != ''">
              <xsl:call-template name="itemSummaryView-show-full"/>
          </xsl:if>
          <xsl:call-template name="itemSummaryView-collections"/>
    </xsl:template>
 <!-- 'relation uri' row in simple item record -->
    <xsl:template name="itemSummaryView-DIM-relation-uri">
        <xsl:if test="dim:field[@element='relation' and @qualifier='uri']">
            <div class="simple-item-view-relationuri item-page-field-wrapper table">
            <h5>Link to Kinder Institute Website</h5>
                 <xsl:for-each select="dim:field[@element='relation' and @qualifier='uri']">
                      <xsl:choose>
                          <xsl:when test="(contains(.,'http://') or contains(.,'https://') )">
                              <xsl:call-template name="makeLinkFromText"/>
                          </xsl:when>
                          <xsl:otherwise>
                              <xsl:copy>
                                  <xsl:call-template name="parse">
                                      <xsl:with-param name="str" select="./node()"/>
                                  </xsl:call-template>
                              </xsl:copy>
                          </xsl:otherwise>
                      </xsl:choose>
                      <br/>

                 </xsl:for-each>
            </div>
         </xsl:if>
    </xsl:template>

</xsl:stylesheet>
