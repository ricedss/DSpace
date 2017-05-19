<?xml version="1.0" encoding="UTF-8"?>

<!--

    Rice_Shepherd.xsl

    XSLT overrides for the "Shepherd School of Music" community in Rice DSpace, mostly 
    related to changes to the simple item record page, since most of the items in this 
    community are audio recordings and thus need to feature different metadata.

    Ying adapted this for the Mirage2
-->

<xsl:stylesheet
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:jstring="java.lang.String"
    xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
    xmlns:confman="org.dspace.core.ConfigurationManager"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights confman">

    <xsl:output indent="yes"/>

    <xsl:template name="simple-item-record-rows">

            <!--xsl:call-template name="itemSummaryView-DIM-alternative-title"/-->
            <xsl:call-template name="itemSummaryView-DIM-authors"/>
            <xsl:call-template name="itemSummaryView-DIM-date"/>
            <xsl:call-template name="itemSummaryView-DIM-description"/>
            <xsl:call-template name="itemSummaryView-DIM-citation"/>
            <xsl:call-template name="itemSummaryView-DIM-subject"/>
            <xsl:call-template name="itemSummaryView-DIM-publisher"/>
        <xsl:call-template name="itemSummaryView-DIM-relation"/>
            <xsl:call-template name="itemSummaryView-DIM-URI"/>
            <xsl:if test="$ds_item_view_toggle_url != ''">
                <xsl:call-template name="itemSummaryView-show-full"/>
            </xsl:if>
            <xsl:call-template name="itemSummaryView-collections"/>
    </xsl:template>

       <xsl:template name="itemSummaryView-DIM-relation">
        <xsl:if test="dim:field[@element='relation'][@qualifier='HasPart' and descendant::text()]
                      or dim:field[@element='relation'][@qualifier='IsPartOf' and descendant::text()]
                      or dim:field[@element='relation'][@qualifier='IsPartOfSeries' and descendant::text()]
                      or dim:field[@element='relation'][@qualifier='IsReferencedBy' and descendant::text()]">

            <div class="simple-item-view-authors item-page-field-wrapper table">
                <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-relation</i18n:text></h5>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='relation'][@qualifier='HasPart']">
                        <xsl:for-each select="dim:field[@element='relation'][@qualifier='HasPart']">
                            <div>

                                <xsl:copy-of select="node()"/> <xsl:text> </xsl:text>
                            </div>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='relation'][@qualifier='IsPartOf']">
                          <xsl:for-each select="dim:field[@element='relation'][@qualifier='IsPartOf']">
                              <div>

                                  <xsl:copy-of select="node()"/> <xsl:text> </xsl:text>
                              </div>
                          </xsl:for-each>
                      </xsl:when>
                    <xsl:when test="dim:field[@element='relation'][@qualifier='IsPartOfSeries']">
                          <xsl:for-each select="dim:field[@element='relation'][@qualifier='IsPartOfSeries']">
                              <div>

                                  <xsl:copy-of select="node()"/> <xsl:text> </xsl:text>
                              </div>
                          </xsl:for-each>
                      </xsl:when>
                    <xsl:when test="dim:field[@element='relation'][@qualifier='IsReferencedBy']">
                          <xsl:for-each select="dim:field[@element='relation'][@qualifier='IsReferencedBy']">
                              <div>

                                  <xsl:copy-of select="node()"/> <xsl:text> </xsl:text>
                              </div>
                          </xsl:for-each>
                      </xsl:when>
                </xsl:choose>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- From item-list.xsl - Generate the info about the item from the metadata section -->
      <xsl:template match="dim:dim" mode="itemSummaryList-DIM-DEBUG">
          <xsl:variable name="itemWithdrawn" select="@withdrawn" />
          <div class="artifact-description">
              <div class="artifact-title">
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
              <span class="Z3988">
                  <xsl:attribute name="title">
                      <xsl:call-template name="renderCOinS"/>
                  </xsl:attribute>
                  &#xFEFF; <!-- non-breaking space to force separating the end tag -->
              </span>
              <div class="artifact-info">
                  <span class="author">
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
                          <xsl:when test="dim:field[@element='contributor']">
                           <xsl:if test="not(dim:field[@element='contributor'][@qualifier='funder'])">


                              <xsl:for-each select="dim:field[@element='contributor']">
                                  <xsl:copy-of select="node()"/>
                                  <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                      <xsl:text>; </xsl:text>
                                  </xsl:if>
                              </xsl:for-each>
                              </xsl:if>
                          </xsl:when>

                          <xsl:otherwise>

                          </xsl:otherwise>
                      </xsl:choose>
                  </span>
                  <xsl:text> </xsl:text>
                  <xsl:if test="dim:field[@element='date' and @qualifier='issued'] or dim:field[@element='publisher']">
                      <span class="publisher-date">
                          <xsl:text>(</xsl:text>
                          <xsl:if test="dim:field[@element='publisher']">
                              <span class="publisher">
                                  <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
                              </span>
                              <xsl:text>, </xsl:text>
                          </xsl:if>
                          <span class="date">
                              <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
                          </span>
                          <xsl:text>)</xsl:text>
                      </span>
                  </xsl:if>
              </div>
          </div>
      </xsl:template>

     <xsl:template name="itemSummaryView-DIM-description">
         <xsl:if test="(dim:field[@element='description' and not(@qualifier)][1]/node())
         or (dim:field[@element='description' and (@qualifier='degree')][1]/node())
         or (dim:field[@element='description' and (@qualifier='note')][1]/node())">
             <div class="simple-item-view-description item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text></h5>
                 <div>
                     <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
                        <xsl:choose>
                            <xsl:when test="(contains(.,'http://') or contains(.,'https://') )">
                                <xsl:call-template name="makeLinkFromText"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."></xsl:value-of><xsl:text> </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                     </xsl:for-each>
                     <xsl:for-each select="dim:field[@element='description' and (@qualifier='degree')]">
                        <xsl:choose>
                            <xsl:when test="(contains(.,'http://') or contains(.,'https://') )">
                                <xsl:call-template name="makeLinkFromText"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."></xsl:value-of><xsl:text> </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                     </xsl:for-each>
                     <xsl:for-each select="dim:field[@element='description' and (@qualifier='note')]">
                        <xsl:choose>
                            <xsl:when test="(contains(.,'http://') or contains(.,'https://') )">
                                <xsl:call-template name="makeLinkFromText"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."></xsl:value-of><xsl:text> </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                     </xsl:for-each>
                 </div>
             </div>
         </xsl:if>
     </xsl:template>

        <!--handles the rendering of a single item in a list in metadata mode-->
     <xsl:template match="dim:dim" mode="itemSummaryList-DIM-metadata-DEBUG">
     <xsl:param name="href"/>
     <div class="artifact-description">
          <h4 class="artifact-title">
              <xsl:element name="a">
                  <xsl:attribute name="href">
                      <xsl:value-of select="$href"/>
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
              <span class="Z3988">
                  <xsl:attribute name="title">
                      <xsl:call-template name="renderCOinS"/>
                  </xsl:attribute>
                  &#xFEFF; <!-- non-breaking space to force separating the end tag -->
              </span>
          </h4>
          <div class="artifact-info">
              <span class="author h4">
                  <small>
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
                      <xsl:when test="dim:field[@element='contributor']">
                          <!-- Ying's note, the code works here for the summarylist-->
                          <xsl:if test="not(dim:field[@element='contributor'][@qualifier='funder'])">
                          <xsl:for-each select="dim:field[@element='contributor']">
                              <xsl:copy-of select="node()"/>
                              <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                  <xsl:text>; </xsl:text>
                              </xsl:if>
                          </xsl:for-each>
                          </xsl:if>
                      </xsl:when>

                      <xsl:otherwise>

                      </xsl:otherwise>
                  </xsl:choose>
                  </small>
              </span>
              <xsl:text> </xsl:text>
              <xsl:if test="dim:field[@element='date' and @qualifier='issued']">
                  <span class="publisher-date h4">  <small>
                      <xsl:text>(</xsl:text>
                      <xsl:if test="dim:field[@element='publisher']">
                          <span class="publisher">
                              <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
                          </span>
                          <xsl:text>, </xsl:text>
                      </xsl:if>
                      <span class="date">
                          <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
                      </span>
                      <xsl:text>)</xsl:text>
                      </small></span>
              </xsl:if>
          </div>
          <xsl:if test="dim:field[@element = 'description' and @qualifier='abstract']">
              <xsl:variable name="abstract" select="dim:field[@element = 'description' and @qualifier='abstract']/node()"/>
              <div class="artifact-abstract">
                  <xsl:value-of select="util:shortenString($abstract, 220, 10)"/>
              </div>
          </xsl:if>
      </div>
  </xsl:template>

    
</xsl:stylesheet>