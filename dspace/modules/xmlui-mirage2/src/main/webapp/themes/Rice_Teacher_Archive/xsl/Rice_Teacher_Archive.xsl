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


    <!-- Ying: Updated this for our new theme -->
    <xsl:template name="simple-item-record-rows">
  <!--                    <xsl:call-template name="itemSummaryView-DIM-URI"/-->
      <xsl:call-template name="itemSummaryView-DIM-authors"/>
      <xsl:call-template name="itemSummaryView-DIM-abstract"/>
      <xsl:call-template name="itemSummaryView-DIM-subject-discipline"/>
       <xsl:call-template name="itemSummaryView-DIM-resource-type"/>
      <xsl:call-template name="itemSummaryView-DIM-audience"/>
      <xsl:call-template name="itemSummaryView-DIM-educationlevel"/>
      <xsl:call-template name="itemSummaryView-DIM-citation"/>
      <xsl:call-template name="itemSummaryView-DIM-uri"/>
      <xsl:call-template name="itemSummaryView-DIM-doi"/>
      <xsl:if test="$ds_item_view_toggle_url != ''">
          <xsl:call-template name="itemSummaryView-show-full"/>
      </xsl:if>
      <xsl:call-template name="itemSummaryView-collections"/>
      </xsl:template>


       <xsl:template name="itemSummaryView-DIM-subject-discipline">
        <xsl:if test="dim:field[@element='subject']">
            <div class="simple-item-view-subject-discipline item-page-field-wrapper table">
                <h5><i18n:text>xmlui.Rice.subjectdiscipline</i18n:text></h5>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='subject'] and descendant::text()">
                        <xsl:for-each select="dim:field[@element='subject']">
                            <div>
                                <xsl:copy-of select="node()"/>
                            </div>
                             <xsl:if test="count(following-sibling::dim:field[@element='subject']) != 0">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- 'Audience' row in simple item record -->
    <xsl:template name="itemSummaryView-DIM-audience">
        <xsl:if test="dim:field[@schema='dcterms' and @element='audience']">
            <div class="simple-item-view-series item-page-field-wrapper table">
            <h5><i18n:text>xmlui.Rice.audience</i18n:text></h5>
                     <xsl:for-each select="dim:field[@schema='dcterms' and @element='audience']">
                         <xsl:copy-of select="./node()"/>
                         <xsl:if test="count(following-sibling::dim:field[@schema='dcterms' and @element='audience') != 0">
                             <br/>
                         </xsl:if>
                     </xsl:for-each>
            </div>
         </xsl:if>
    </xsl:template>

    <!-- 'Resource Type' row in simple item record -->
     <xsl:template name="itemSummaryView-DIM-resourcetype">
         <xsl:if test="dim:field[@schema='local' and @element='educational' and @qualifier='resourceType']">
             <div class="simple-item-view-series item-page-field-wrapper table">
             <h5><i18n:text>xmlui.Rice.resourcetype</i18n:text></h5>
                      <xsl:for-each select="dim:field[dim:field[@schema='local' and @element='educational' and @qualifier='resourceType']">
                          <xsl:copy-of select="./node()"/>
                          <xsl:if test="count(following-sibling::dim:field[@schema='local' and @element='educational' and @qualifier='resourceType']) != 0">
                              <br/>
                          </xsl:if>
                      </xsl:for-each>
             </div>
          </xsl:if>
     </xsl:template>

    <!-- 'Education Level' row in simple item record -->
    <xsl:template name="itemSummaryView-DIM-educationlevel">
        <xsl:if test="dim:field[@schema='dcterms' and @element='educationLevel']">
            <div class="simple-item-view-educationlevel item-page-field-wrapper table">
            <h5><i18n:text>xmlui.Rice.educationlevel</i18n:text></h5>
                     <xsl:for-each select="dim:field[@schema='dcterms' and @element='educationLevel']">
                         <xsl:copy-of select="./node()"/>
                         <xsl:if test="count(following-sibling::dim:field[@schema='dcterms' and @element='educationLevel']) != 0">
                             <br/>
                         </xsl:if>
                     </xsl:for-each>
            </div>
         </xsl:if>
    </xsl:template>


</xsl:stylesheet>
