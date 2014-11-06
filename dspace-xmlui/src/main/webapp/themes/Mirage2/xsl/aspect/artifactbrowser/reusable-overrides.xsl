<?xml version="1.0" encoding="UTF-8"?>

<!--
    
    reusable-overrides.xsl
    
    Description: This file contains template overrides that have been found to have use in multiple 
    themes, even when those themes are of drastically different appearance (e.g. the Rice theme vs. 
    the Americas theme).  It allows themes to avoid pulling in all of Rice.xsl to get certain basic
    functionality.  The template may include what we might consider bug fixes or feature additions 
    to the base set of stylesheets provided by DSpace.  However, depending on the circumstances, even 
    these overrides may need to be overridden (e.g. the Shepherd School theme displays "mets:file" 
    differently).  
    
    It differs from reusable-new-templates.xsl in that it contains overrides of templates that have 
    already been defined elsewhere (mostly in the base set of DSPace stylesheets) or that are very 
    similar to those defined elsewhere but with a greater specificity applied.
    
    Author: Max Starkenburg
    Author: Ying Jin
    Author: Sid Byrd
    Author: Alexey Maslov (original author of many of the overridden templates, to which we have, in some cases, just made small edits)
    
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

    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:jstring="java.lang.String"
    xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
    xmlns:confman="org.dspace.core.ConfigurationManager"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights confman">

    <xsl:param name="browser" />

    <!-- TODO: Adding this can break the search "GO" and "login" buttons etc...WHY!!!!

    Ying:from core/elements.xsl -
        Non-interactive divs get turned into HTML div tags. The general process, which is found in many
        templates in this stylesheet, is to call the template for the head element (creating the HTML h tag),
        handle the attributes, and then apply the templates for the all children except the head. The id
        attribute is -->
    <xsl:template match="dri:div--DEBUG" priority="1">
        <xsl:apply-templates select="dri:head"/>
        <xsl:apply-templates select="@pagination">
            <xsl:with-param name="position">top</xsl:with-param>
        </xsl:apply-templates>
        <div>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-static-div</xsl:with-param>
            </xsl:call-template>
            <xsl:choose>
                <!--  does this element have any children -->
                <xsl:when test="child::node()">
                    <xsl:apply-templates select="*[not(name()='head')]"/>
                </xsl:when>
                <!-- if no children are found we add a space to eliminate self closing tags -->
                <xsl:otherwise>
                    &#160;
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <xsl:variable name="itemDivision">
            <xsl:value-of select="@n"/>
        </xsl:variable>
        <xsl:variable name="xrefTarget">
            <xsl:value-of select="./dri:p/dri:xref/@target"/>
        </xsl:variable>
        <xsl:if test="$itemDivision='item-view'">
            <xsl:call-template name="cc-license">
                <xsl:with-param name="metadataURL" select="./dri:referenceSet/dri:reference/@url"/>
            </xsl:call-template>

            <xsl:call-template name="rights-statement">
                   <xsl:with-param name="metadataURL" select="./dri:referenceSet/dri:reference/@url"/>
               </xsl:call-template>

        </xsl:if>
        <xsl:apply-templates select="@pagination">
            <xsl:with-param name="position">bottom</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

       <!--Ying: The rights statement: updated from cc-license in core/page-structure.xsl-->
    <xsl:template name="rights-statement">
        <xsl:param name="metadataURL"/>
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="$metadataURL"/>
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
        </xsl:variable>
                <xsl:variable name="handleUri">
            <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
                <a>
                    <xsl:attribute name="href">
                        <xsl:copy-of select="./node()"/>
                    </xsl:attribute>
                    <xsl:copy-of select="./node()"/>
                </a>
                <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

                  <!-- Add "Rights and Usage" section for any dc.rights and dc.rights.uri fields -->
            <xsl:if test="document($externalMetadataURL)//dim:field[@element='rights']">
                <div about="{$handleUri}" class="row">
                    <div class="col-sm-3 col-xs-12">
                        <!-- i18n: Rights and Usage -->
                        <!--i18n:text>xmlui.Rice.RightsAndUsage</i18n:text-->
                        <img class="img-responsive">
                             <xsl:attribute name="src">
                                 <xsl:value-of select="concat($theme-path,'/images/340px-Copyright.svg.png')"/>
                                 <!--xsl:value-of select="concat($theme-path,'/images/rights.jpg')"/-->
                             </xsl:attribute>
                         </img>

                    </div> <div class="col-sm-8">
                           <span>
                               <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='rights']">
                                <xsl:choose>
                                    <xsl:when test="contains(.,'http://')">
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
                        </span>
                    </div>
                </div>
            </xsl:if>

    <!--    <xsl:variable name="ccLicenseName"
                      select="document($externalMetadataURL)//dim:field[@element='rights']"
                />
        <xsl:variable name="ccLicenseUri"
                      select="document($externalMetadataURL)//dim:field[@element='rights'][@qualifier='uri']"
                />
        <xsl:variable name="handleUri">
            <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
                <a>
                    <xsl:attribute name="href">
                        <xsl:copy-of select="./node()"/>
                    </xsl:attribute>
                    <xsl:copy-of select="./node()"/>
                </a>
                <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="$ccLicenseName and $ccLicenseUri and contains($ccLicenseUri, 'creativecommons')">
            <div about="{$handleUri}" class="row">
            <div class="col-sm-3 col-xs-12">
                <a rel="license"
                   href="{$ccLicenseUri}"
                   alt="{$ccLicenseName}"
                   title="{$ccLicenseName}"
                        >
                    <img class="img-responsive">
                        <xsl:attribute name="src">
                            <xsl:value-of select="concat($theme-path,'/images/cc-ship.gif')"/>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:value-of select="$ccLicenseName"/>
                        </xsl:attribute>
                    </img>
                </a>
            </div> <div class="col-sm-8">
                <span>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.cc-license-text</i18n:text>
                    <xsl:value-of select="$ccLicenseName"/>
                </span>
            </div>
            </div>
        </xsl:if>   -->
    </xsl:template>

    <!-- we have no setup for xmlui.theme.mirage.item-list.emphasis, just hard coded with 'file' -->
     <xsl:template name="itemSummaryList-DIM">
        <xsl:variable name="itemWithdrawn" select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/@withdrawn" />

        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="$itemWithdrawn">
                    <xsl:value-of select="@OBJEDIT"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@OBJID"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- confman:getProperty('xmlui.theme.mirage.item-list.emphasis') -->
        <xsl:variable name="emphasis" select="'file'"/>
        <xsl:choose>
            <xsl:when test="'file' = $emphasis">


                <div class="item-wrapper row">
                    <div class="col-sm-3 hidden-xs">
                        <xsl:apply-templates select="./mets:fileSec" mode="artifact-preview">
                            <xsl:with-param name="href" select="$href"/>
                        </xsl:apply-templates>
                    </div>

                    <div class="col-sm-9">
                        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                                             mode="itemSummaryList-DIM-metadata">
                            <xsl:with-param name="href" select="$href"/>
                        </xsl:apply-templates>
                    </div>

                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                                     mode="itemSummaryList-DIM-metadata"><xsl:with-param name="href" select="$href"/></xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ============================================
                     Reference listings
         ============================================ -->
    
    <!-- Ying (via MMS): Find the first thumbnail to display in summary list page. -->
    <xsl:template match="mets:fileGrp[@USE='THUMBNAIL']/mets:file" mode="thumbnail">
        <xsl:if test="position()=1">
            <a href="{ancestor::mets:METS/@OBJID}">
                <img alt="Thumbnail">
                    <xsl:attribute name="src">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                    </xsl:attribute>
                </img>
            </a>
        </xsl:if>
    </xsl:template>



    <!-- ============================================
                   Item record page (general)
         ============================================ -->
    
    <!-- MMS: Copied from General-Handler.xsl with what appears to be several customizations for different file types (Ying or Sid could elaborate). -->


    <!-- Ying: Updated this for our new theme -->
     <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
         <div class="item-summary-view-metadata">
             <xsl:call-template name="itemSummaryView-DIM-title"/>
             <div class="row">
                      <!-- Generate the bitstream information from the file section -->
        <xsl:choose>
            <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE']/mets:file">
                <!--h3><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h3-->
                <div class="file-list">
                    <xsl:apply-templates select="//mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='LICENSE' or @USE='CC-LICENSE']">
                        <xsl:with-param name="context" select="//mets:METS"/>
                        <xsl:with-param name="primaryBitstream" select="//mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
            <!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
            <xsl:when test="//mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="//mets:fileSec/mets:fileGrp[@USE='ORE']"/>
            </xsl:when>
            <xsl:otherwise>
                <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
                <table class="ds-table file-list">
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
                        </td>
                    </tr>
                </table>
            </xsl:otherwise>
        </xsl:choose>
             <!--    <div class="col-sm-12">
                     <div class="row">
                         <div class="col-xs-6 col-sm-6">
                             <xsl:call-template name="itemSummaryView-DIM-thumbnail"/>
                         </div>
                         <div class="col-xs-6 col-sm-6">
                             <xsl:call-template name="itemSummaryView-DIM-file-section"/>
                         </div>
                     </div>
                 </div>   -->
                 <div class="col-sm-12">
                     <xsl:call-template name="simple-item-record-rows"/>
                 </div>
             </div>
         </div>
     </xsl:template>

     <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
         <xsl:variable name="bitstreamurl" select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
         <xsl:variable name="streamingfilename">
             <xsl:value-of select="@ID"/>_<xsl:value-of select="mets:FLocat/@xlink:title"/>
         </xsl:variable>

        <div class="file-wrapper row">
            <div class="col-xs-6 col-sm-3">
                <div class="thumbnail">
                    <a class="image-link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                        </xsl:attribute>
                        <xsl:choose>

                        <xsl:when test="@MIMETYPE='image/jp2'">
                            <a class="image-link" href="javascript:showJPEG2000Viewer('{$bitstreamurl}')">
                                <img alt="Thumbnail">
                                    <xsl:attribute name="src">
                                        <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                            mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                </img>
                            </a>
                        </xsl:when>

                        <xsl:when test="@MIMETYPE='video/mp4'">

                          <!-- With JWPlayer 6 -->

                          <div id="{$streamingfilename}">Loading the player...</div>
                            <xsl:variable name="mp4thumb" select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                          <script type="text/javascript">


                            jwplayer('<xsl:value-of select="$streamingfilename"/>').setup({

                            playlist: [{
                                image: "<xsl:value-of select='$mp4thumb'/>",
                            sources: [{
                              file: "rtmp://fldp.rice.edu/fondren/mp4:<xsl:value-of select='$streamingfilename'/>"
                            },{
                              file: "/themes/Rice/streaming/<xsl:value-of select='$streamingfilename'/>"
                            }]
                            }],

                            rtmp: {
                              bufferlength: 10
                            },
                            primary: "flash",
                            stretching: "exactfit",
                            height: 172,
                            width: 300


                            });
                          </script>

                    </xsl:when>
                    <xsl:when test="@MIMETYPE='audio/x-mp3'">

                                <!-- With JWPlayer 6 -->

                                  <div id="{$streamingfilename}">Loading the player...</div>

                                  <script type="text/javascript">


                                    jwplayer('<xsl:value-of select="$streamingfilename"/>').setup({

                                    playlist: [{

                                    sources: [{
                                      file: "rtmp://fldp.rice.edu/fondren/mp3:<xsl:value-of select='$streamingfilename'/>"
                                    },{
                                      file: "/themes/Rice/streaming/<xsl:value-of select='$streamingfilename'/>"
                                    }]
                                    }],

                                    rtmp: {
                                      bufferlength: 10
                                    },
                                    primary: "flash",
                                    height: 30,
                                    width: 320
                                    });
                                  </script>

                            </xsl:when>
                            <xsl:otherwise>
                               <xsl:choose>
                                    <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                        mets:file[@GROUPID=current()/@GROUPID]">
                                        <img alt="Thumbnail">
                                            <xsl:attribute name="src">
                                                <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                            mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                            </xsl:attribute>
                                        </img>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <img alt="Thumbnail">
                                            <xsl:attribute name="data-src">
                                                <xsl:text>holder.js/100%x</xsl:text>
                                                <xsl:value-of select="$thumbnail.maxheight"/>
                                                <xsl:text>/text:No Thumbnail</xsl:text>
                                            </xsl:attribute>
                                        </img>
                                    </xsl:otherwise>
                                </xsl:choose>
                        </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </div>
            </div>

            <div class="col-xs-6 col-sm-7">
                <dl class="file-metadata dl-horizontal">
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-name</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:attribute name="title">
                            <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                        </xsl:attribute>
                        <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:title, 30, 5)"/>
                    </dd>
                <!-- File size always comes in bytes and thus needs conversion -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:choose>
                            <xsl:when test="@SIZE &lt; 1024">
                                <xsl:value-of select="@SIZE"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                            </xsl:when>
                            <xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </dd>
                <!-- Lookup File Type description in local messages.xml based on MIME Type.
         In the original DSpace, this would get resolved to an application via
         the Bitstream Registry, but we are constrained by the capabilities of METS
         and can't really pass that info through. -->
                    <dt>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text>
                        <xsl:text>:</xsl:text>
                    </dt>
                    <dd class="word-break">
                        <xsl:call-template name="getFileTypeDesc">
                            <xsl:with-param name="mimetype">
                                <xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                                <xsl:text>/</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="contains(@MIMETYPE,';')">
                                <xsl:value-of select="substring-before(substring-after(@MIMETYPE,'/'),';')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
                                    </xsl:otherwise>
                                </xsl:choose>

                            </xsl:with-param>
                        </xsl:call-template>
                    </dd>
                <!-- Display the contents of 'Description' only if bitstream contains a description -->
                <xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
                        <dt>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text>
                            <xsl:text>:</xsl:text>
                        </dt>
                        <dd class="word-break">
                            <xsl:attribute name="title">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                            </xsl:attribute>
                            <xsl:value-of select="util:shortenString(mets:FLocat[@LOCTYPE='URL']/@xlink:label, 30, 5)"/>
                        </dd>
                </xsl:if>
                </dl>
            </div>

            <div class="file-link col-xs-6 col-xs-offset-6 col-sm-2 col-sm-offset-0">
                <xsl:choose>
                    <xsl:when test="@ADMID">
                        <xsl:call-template name="display-rights"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="view-open"/>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>

</xsl:template>

    <xsl:template name="simple-item-record-rows">

    <!--                    <xsl:call-template name="itemSummaryView-DIM-URI"/-->
                        <xsl:call-template name="itemSummaryView-DIM-authors"/>
                        <xsl:call-template name="itemSummaryView-DIM-date"/>
                        <xsl:call-template name="itemSummaryView-DIM-citation"/>
                        <xsl:call-template name="itemSummaryView-DIM-doi"/>
                        <xsl:call-template name="itemSummaryView-DIM-subject"/>
                        <xsl:call-template name="itemSummaryView-DIM-abstract"/>
                        <xsl:if test="$ds_item_view_toggle_url != ''">
                            <xsl:call-template name="itemSummaryView-show-full"/>
                        </xsl:if>
                        <xsl:call-template name="itemSummaryView-collections"/>
</xsl:template>

     <xsl:template name="itemSummaryView-DIM-citation">
          <xsl:if test="dim:field[@element='identifier'][@qualifier='citation']">
              <div class="simple-item-view-citation item-page-field-wrapper table">
              <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-citation</i18n:text></h5>
                  <div>
                      <xsl:copy>
                          <xsl:call-template name="parse">
                              <xsl:with-param name="str" select="dim:field[@element='identifier'][@qualifier='citation'][1]/node()"/>
                              <xsl:with-param name="omit-link" select="1"/>
                          </xsl:call-template>
                      </xsl:copy>
                  </div>
              </div>
          </xsl:if>
      </xsl:template>
      <xsl:template name="itemSummaryView-DIM-doi">
          <xsl:if test="dim:field[@element='identifier' and @qualifier='doi']">
          <div class="simple-item-view-doi item-page-field-wrapper table">
              <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-doi</i18n:text></h5>
                  <div>
                      <xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
                          <xsl:copy-of select="./node()"/>
                          <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
                              <br/>
                          </xsl:if>
                      </xsl:for-each>
                  </div>
              </div>
          </xsl:if>
      </xsl:template>

    <!-- 'Series' row in simple item record -->
    <xsl:template name="itemSummaryView-DIM-series">
        <xsl:if test="dim:field[@element='relation' and @qualifier='ispartofseries']">
            <div class="simple-item-view-series item-page-field-wrapper table">
            <h5><i18n:text>xmlui.ArtifactBrowser.AdvancedSearch.type_series</i18n:text></h5>
                     <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries']">
                         <xsl:copy-of select="./node()"/>
                         <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
                             <br/>
                         </xsl:if>
                     </xsl:for-each>
            </div>
         </xsl:if>
    </xsl:template>

     <!-- 'Issue' row in simple item record -->
     <xsl:template name="itemSummaryView-DIM-issue">
         <xsl:variable name="query_string" select="$document/dri:meta/dri:pageMeta/dri:metadata[@element='search' and @qualifier='queryField']"/>
         <xsl:variable name="context_path" select="$document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
         <xsl:variable name="collection_handle" select="substring-after($document/dri:meta/dri:pageMeta/dri:metadata[@element='focus' and @qualifier='container'], ':')"/>
         <xsl:variable name="num" select="dim:field[@element='citation' and @qualifier='issueNumber']"/>
         <xsl:variable name="vol" select="dim:field[@element='citation' and @qualifier='volumeNumber']"/>
         <xsl:if test="dim:field[@element='relation' and @qualifier='ispartofseries']">
             <div class="simple-item-view-issue item-page-field-wrapper table">

                     <xsl:choose>
                         <xsl:when test="contains($num, 'Special Issue') ">
                                 <h5><i18n:text>xmlui.Periodicals.Issue</i18n:text>:</h5>
                             <div>
                                     <a href="{$context_path}/handle/{$collection_handle}/search?{$query_string}=series%3A%28%22Volume+{$vol}%2C+,%20+{$num}%22+-%22Page%22%29">Issue <xsl:value-of select="$num"/></a>
                             </div>
                         </xsl:when>
                         <xsl:when test="contains($num, 'Supplement')">

                         </xsl:when>
                         <xsl:otherwise>
                                  <h5><i18n:text>xmlui.Periodicals.Issue</i18n:text>:</h5>
                             <div>
                                     Issue <xsl:value-of select='$num'/>
                                 </div>
                         </xsl:otherwise>
                     </xsl:choose>
             </div>
         </xsl:if>
     </xsl:template>


  <!--      <xsl:template name="itemSummaryView-DIM-subject-keyword">
          <xsl:if test="dim:field[@element='subject'][@qualifier='keyword']">
          <div class="simple-item-view-keyword item-page-field-wrapper table">
              <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-keyword</i18n:text></h5>
                  <div>
                      <xsl:if test="count(following-sibling::dim:field[@element='subject'][@qualifier='keyword']) >= 5">
                          <xsl:for-each select="dim:field[@element='subject'][@qualifier='keyword']">
                          <xsl:if test="position() &lt;= 5">
                              <span>
                                  <xsl:copy-of select="node()"/>
                              </span>
                              <xsl:text>; </xsl:text>
                          </xsl:if>
                      </xsl:for-each>
                      <span class="show-hide" style="display: none;">
                          <xsl:text>[ </xsl:text>
                          <span class="show"><i18n:text>xmlui.Periodicals.show</i18n:text></span>
                          <span class="hide" style="display: none;"><i18n:text>xmlui.Periodicals.hide</i18n:text></span>
                          <xsl:text> ]</xsl:text>
                      </span>

                       <div class="hiddenfield">

                          <span class="hiddenvalue">
                          <xsl:for-each select="dim:field[@element='subject'][@qualifier='keyword']">
                          <xsl:if test="position() >= 5">
                                  <xsl:copy-of select="node()"/>
                              <xsl:text>; </xsl:text>
                          </xsl:if>
                          </xsl:for-each>
                          </span>
                       </div>
                  </xsl:if>
                      <xsl:if test="count(following-sibling::dim:field[@element='subject'][@qualifier='keyword']) &lt;= 5">
                                              <xsl:for-each select="dim:field[@element='subject'][@qualifier='keyword']">
                                                  <span>
                                                      <xsl:copy-of select="node()"/>
                                                  </span>
                                                  <xsl:text>; </xsl:text>
                                          </xsl:for-each>
                      </xsl:if>

                          </div>
              </div>
          </xsl:if>
      </xsl:template>-->

    <xsl:template name="itemSummaryView-DIM-date-recorded">
         <xsl:if test="dim:field[@element='date' and @qualifier='created']">
             <div class="simple-item-view-date-recorded item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.Shepherd.Daterecorded</i18n:text></h5>
                 <div>
                     <xsl:for-each select="dim:field[@element='date' and @qualifier='created']">
                           <xsl:call-template name="displayDate">
                               <xsl:with-param name="iso" select="./node()"/>
                           </xsl:call-template>
                           <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
                               <br/>
                           </xsl:if>
                       </xsl:for-each>
                   </div>
             </div>
          </xsl:if>
     </xsl:template>

      <xsl:template name="itemSummaryView-DIM-subject">
          <xsl:if test="dim:field[@element='subject']">
          <div class="simple-item-view-keyword item-page-field-wrapper table">
              <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-keyword</i18n:text></h5>
                  <div>

                      <xsl:variable name="cc" select="count(dim:field[@element='subject']/node())" />

                      <xsl:if test="$cc != 0">
                          <xsl:for-each select="dim:field[@element='subject']">
                          <xsl:if test="position() &lt;= 5">
                              <span>

                                  <xsl:copy-of select="node()"/>
                              </span>
                              <xsl:text>; </xsl:text>
                          </xsl:if>
                      </xsl:for-each>

                      <xsl:if test="$cc &gt; 5">
                          <div>
                          <div class="hiddenfield">
                          <span class="show-hide" style="display: none;">
                          <span class="show"><i18n:text>xmlui.Periodicals.show</i18n:text></span>
                          <span class="hide" style="display: none;"><i18n:text>xmlui.Periodicals.hide</i18n:text></span>
                      </span>
                          </div>
                          </div>
                          <div>
                          <div  class="hiddenvalue">
                          <span>
                          <xsl:for-each select="dim:field[@element='subject']">
                          <xsl:if test="position() > 5">
                                  <xsl:copy-of select="node()"/>
                              <xsl:text>; </xsl:text>
                          </xsl:if>
                          </xsl:for-each>
                          </span>
                       </div>
                          </div>

                  </xsl:if>
                 </xsl:if>
              </div>
              </div>
          </xsl:if>
      </xsl:template>

    <xsl:template name="itemSummaryView-DIM-abstract">
         <xsl:if test="dim:field[@element='description' and @qualifier='abstract']">
             <div class="simple-item-view-description item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h5>
                 <div>
                     <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                         <xsl:choose>
                             <xsl:when test="node()">
                                 <xsl:copy-of select="node()"/>
                             </xsl:when>
                             <xsl:otherwise>
                                 <xsl:text>&#160;</xsl:text>
                             </xsl:otherwise>
                         </xsl:choose>
                         <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                             <div class="spacer">&#160;</div>
                         </xsl:if>
                     </xsl:for-each>
                     <xsl:if test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">
                         <div class="spacer">&#160;</div>
                     </xsl:if>
                 </div>
             </div>
         </xsl:if>
     </xsl:template>

    <xsl:template name="itemSummaryView-DIM-subject-keyword">
         <xsl:if test="dim:field[@element='subject' and @qualifier='keyword']">
             <div class="simple-item-view-subject-keyword item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.Rice.Subject.Keywords</i18n:text></h5>
                 <div>
                     <xsl:for-each select="dim:field[@element='subject' and @qualifier='keyword']">
                         <xsl:value-of select="."/>
                         <xsl:if test="count(following-sibling::dim:field[@element='subject' and @qualifier='keyword']) != 0">
                             <xsl:text>; </xsl:text>
                         </xsl:if>
                     </xsl:for-each>
                 </div>
             </div>
         </xsl:if>
     </xsl:template>

    <xsl:template name="itemSummaryView-DIM-translator">
         <xsl:if test="dim:field[@element='contributor' and @qualifier='translator']">
             <div class="simple-item-view-performer item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.Rice.Translator</i18n:text></h5>
                 <div>
                     <xsl:for-each select="dim:field[@element='contributor'][@qualifier='translator']">
                         <xsl:copy-of select="node()"/>
                         <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='translator']) != 0">
                             <xsl:text>; </xsl:text>
                         </xsl:if>
                      </xsl:for-each>
                  </div>
             </div>
          </xsl:if>
     </xsl:template>

    <xsl:template name="itemSummaryView-DIM-publisher">
         <xsl:if test="dim:field[@element='publisher']">
             <div class="simple-item-view-publisher item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-publisher</i18n:text></h5>
                 <div>
                     <xsl:copy>
                         <xsl:call-template name="parse">
                             <xsl:with-param name="str" select="dim:field[@element='publisher' and not(@qualifier)][1]/node()"/>
                         </xsl:call-template>
                     </xsl:copy>
                 </div>
             </div>
         </xsl:if>
     </xsl:template>

    <xsl:template name="itemSummaryView-DIM-description">
         <xsl:if test="dim:field[@element='description' and not(@qualifier)][1]/node()">
             <div class="simple-item-view-description item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text></h5>
                 <div>
                     <xsl:copy>
                         <xsl:call-template name="parse">
                             <xsl:with-param name="str" select="dim:field[@element='description' and not(@qualifier)][1]/node()"/>
                         </xsl:call-template>
                     </xsl:copy>
                 </div>
             </div>
         </xsl:if>
     </xsl:template>

    <xsl:template name="itemSummaryView-DIM-type">
         <xsl:if test="dim:field[@element='type' and not(@qualifier)]/child::node()">
             <div class="simple-item-view-type item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-type</i18n:text></h5>
                 <div>
                     <xsl:copy-of select="dim:field[@element='type' and not(@qualifier)]/child::node()"/>
                 </div>
             </div>
         </xsl:if>
     </xsl:template>

    <xsl:template name="itemSummaryView-DIM-description-center">
         <xsl:if test="dim:field[@element='description' and @qualifier='center']">
             <div class="simple-item-view-description-center item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.Rice.Description.Center</i18n:text></h5>
                 <div>
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
                 </div>
             </div>
         </xsl:if>
     </xsl:template>
    <xsl:template name="itemSummaryView-DIM-alternative-title">
      <xsl:if test="dim:field[@element='title' and @qualifier='alternative']">
          <div class="simple-item-view-description item-page-field-wrapper table">
              <h5><i18n:text>xmlui.Rice.Alttitle</i18n:text></h5>
              <div>
                  <xsl:copy-of select="dim:field[@element='title'][@qualifier='alternative']"/>
              </div>
          </div>
      </xsl:if>
  </xsl:template>

 <xsl:template name="itemSummaryView-DIM-subject-lcsh">
     <xsl:if test="dim:field[@element='subject' and @qualifier='lcsh']">
         <div class="simple-item-view-subject-lcsh item-page-field-wrapper table">
             <h5><i18n:text>xmlui.Rice.Subject.LCSH</i18n:text></h5>
             <div>
                 <xsl:for-each select="dim:field[@element='subject'][@qualifier='lcsh']">
                      <xsl:copy-of select="."/>
                      <xsl:if test="following::dim:field[@element='subject'][@qualifier='lcsh']">
                          <br/>
                      </xsl:if>
                  </xsl:for-each>
                </div>
         </div>
      </xsl:if>
 </xsl:template>

    <!-- 'composer' row in simple item record -->
     <xsl:template name="itemSummaryView-DIM-composer">
         <xsl:if test="dim:field[@element='contributor' and @qualifier='composer']">
             <div class="simple-item-view-composer item-page-field-wrapper table">
                 <xsl:choose>
                      <xsl:when test="count(dim:field[@element='contributor'][@qualifier='composer']) &gt; 0">
                          <!-- i18n: Composers -->
                          <h5><i18n:text>xmlui.Shepherd.Composers</i18n:text></h5>
                      </xsl:when>
                      <xsl:otherwise>
                          <!-- i18n: Composer -->
                          <h5><i18n:text>xmlui.Shepherd.Composer</i18n:text></h5>
                      </xsl:otherwise>
                  </xsl:choose>
                 <div>
                   <xsl:for-each select="dim:field[@element='contributor'][@qualifier='composer']">
                      <xsl:copy-of select="node()"/>
                      <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='composer']) != 0">
                          <xsl:text>; </xsl:text>
                      </xsl:if>
                   </xsl:for-each>
                 </div>
             </div>
          </xsl:if>
     </xsl:template>



    <!-- Ying (via MMS): 'Advisor' row in simple item record -->
    <xsl:template name="itemSummaryView-DIM-advisor">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='advisor']">
             <div class="simple-item-view-advisor item-page-field-wrapper table">
                <h5><i18n:text>xmlui.dri2xhtml.METS-1.0.item-advisor</i18n:text></h5>
                <div>
                   <xsl:for-each select="dim:field[@element='contributor'][@qualifier='advisor']">
                        <xsl:copy-of select="node()"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='advisor']) != 0">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </div>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- Ying (via MMS): 'Degree' row in simple item record -->
    <xsl:template name="itemSummaryView-DIM-degree">
        <xsl:if test="dim:field[@element='degree'][@qualifier='name']">
              <div class="simple-item-view-degree item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.Rice_ETD.Degree</i18n:text></h5>
                 <div>
                    <xsl:for-each select="dim:field[@element='degree' and @qualifier='name']">
                        <xsl:copy-of select="./node()"/>
                        <xsl:text> thesis</xsl:text>
                        <xsl:if test="count(following-sibling::dim:field[@element='degree' and @qualifier='name']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </div>
            </div>
        </xsl:if>
    </xsl:template>


     <!-- 'Preformed by' row in simple item record -->
     <xsl:template name="itemSummaryView-DIM-performer">
         <xsl:if test="dim:field[@element='contributor' and @qualifier='performer']">
             <div class="simple-item-view-performer item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.Shepherd.Performedby</i18n:text></h5>
                 <div>
                   <xsl:for-each select="dim:field[@element='contributor'][@qualifier='performer']">
                     <xsl:choose>
                         <xsl:when test="dim:field[@element='contributor'][@qualifier='performer']">
                             <xsl:for-each select="dim:field[@element='contributor'][@qualifier='performer']">
                                 <xsl:copy-of select="node()"/>
                                 <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='performer']) != 0">
                                     <br />
                                 </xsl:if>
                             </xsl:for-each>
                         </xsl:when>
                         <xsl:otherwise>
                             <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                         </xsl:otherwise>
                     </xsl:choose>
                     </xsl:for-each>
                 </div>
             </div>
          </xsl:if>
     </xsl:template>

     <xsl:template name="itemSummaryView-DIM-performance-type">
         <xsl:if test="dim:field[@element='subject' and @qualifier='performancetype']">
             <div class="simple-item-view-performance-type item-page-field-wrapper table">
                 <h5><i18n:text>xmlui.Shepherd.Performancetype</i18n:text></h5>
                 <div>
                   <xsl:for-each select="dim:field[@element='contributor'][@qualifier='performer']">
                     <xsl:choose>
                         <xsl:when test="dim:field[@element='subject'][@qualifier='performancetype']">
                             <xsl:for-each select="dim:field[@element='subject'][@qualifier='performancetype']">
                                 <xsl:copy-of select="node()"/>
                                 <xsl:if test="count(following-sibling::dim:field[@element='subject'][@qualifier='performancetype']) != 0">
                                     <xsl:text>; </xsl:text>
                                 </xsl:if>
                             </xsl:for-each>
                         </xsl:when>
                         <xsl:otherwise>
                             <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                         </xsl:otherwise>
                     </xsl:choose>
                     </xsl:for-each>
                 </div>
             </div>
          </xsl:if>
     </xsl:template>


    <xsl:template name="displayDate">
         <xsl:param name="iso"/>
         <xsl:variable name="firstChar" select="substring($iso,1,1)" />
         <xsl:choose>
             <xsl:when test="$firstChar = '-'">
                 <xsl:call-template name="displayDate">
                     <xsl:with-param name="iso">
                         <xsl:value-of select="number(substring-before(substring(concat($iso,'-'),2),'-'))+1"/>
                         <xsl:if test="substring-after(substring($iso,2),'-') != ''">
                             <xsl:text>-</xsl:text>
                             <xsl:value-of select="substring-after(substring($iso,2),'-')"/>
                         </xsl:if>
                     </xsl:with-param>
                 </xsl:call-template>
                 <xsl:text> BCE</xsl:text>
             </xsl:when>
             <xsl:when test="$firstChar = '0'">
                 <xsl:call-template name="displayDate">
                     <xsl:with-param name="iso" select="substring($iso,2)"/>
                 </xsl:call-template>
             </xsl:when>
             <xsl:otherwise>
                 <xsl:value-of select="substring($iso,1,10)"/>
             </xsl:otherwise>
         </xsl:choose>
     </xsl:template>


    <!-- ============================================
              Item record page (full record table)
         ============================================ -->
    
    <!-- MMS: copied from DIM-Handler.xsl for special handling of certain fields in the "Full item record" table, and for removal of the language column. 
         Like fields are combined under a single header instead of of each getting their own row, since the tables were getting too tall.  
         Remove odd/even class determination (let JS do that instead). -->
    <xsl:template match="dim:field" mode="itemDetailView-DIM">
        <!-- Ying: Set field name as a variable for easy retrieval in tests below. -->
        <xsl:variable name="metadatafieldname">
            <xsl:value-of select="./@mdschema"/>
            <xsl:text>.</xsl:text>
            <xsl:value-of select="./@element"/>
            <xsl:if test="./@qualifier">
                <xsl:text>.</xsl:text>
                <xsl:value-of select="./@qualifier"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <!-- Ying (via MMS): If this is the provenance field, set classes that make its value initially hidden, but expandable with JS on -->
            <xsl:when test="$metadatafieldname='dc.description.provenance'">
                <tr class="ds-table-row">
                    <th>
                        <div class="hiddenfield">
                            <xsl:copy-of select="$metadatafieldname" />
                        </div>
                    </th>
                    <td>
                        <div class="hiddenvalue">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="./@authority and ./@confidence">
                                <xsl:call-template name="authorityConfidenceIcon">
                                    <xsl:with-param name="confidence" select="./@confidence"/>
                                </xsl:call-template>
                            </xsl:if>
                        </div>
                    </td>
                </tr>
            </xsl:when>
            <!-- Ying (via MMS): If this field is a URL, turn it into a link -->
            <xsl:when test="$metadatafieldname='dc.rights.uri' or $metadatafieldname='dc.identifier.uri' or $metadatafieldname='dc.relations'">
                <tr class="ds-table-row">
                    <th>
                        <xsl:copy-of select="$metadatafieldname" />
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
                        <xsl:if test="./@authority and ./@confidence">
                            <xsl:call-template name="authorityConfidenceIcon">
                                <xsl:with-param name="confidence" select="./@confidence"/>
                            </xsl:call-template>
                        </xsl:if>
                    </td>
                </tr>
            </xsl:when>
            <!-- MMS: Put like fields together to take up less space. -->
            <xsl:when test="$metadatafieldname='dc.contributor.author' or 
                            $metadatafieldname='dc.contributor.translator' or 
                            $metadatafieldname='dc.subject.keyword' or 
                            $metadatafieldname='dc.subject.lcsh' or 
                            $metadatafieldname='dc.subject.local' or 
                            $metadatafieldname='dc.subject.other' or 
                            $metadatafieldname='dc.description.funder' or 
                            $metadatafieldname='dc.coverage.spatial' or 
                            $metadatafieldname='dc.identifier.issn'">
                <tr class="ds-table-row">
                    <xsl:if test="not(preceding-sibling::dim:field[@element=current()/@element and @qualifier=current()/@qualifier])">
                        <th>
                            <xsl:copy-of select="$metadatafieldname" />
                        </th>
                        <td>
                            <xsl:for-each select="parent::dim:dim/dim:field[@element=current()/@element and @qualifier=current()/@qualifier]">
                                <xsl:copy-of select="./node()"/>
                                <xsl:if test="./@authority and ./@confidence">
                                    <xsl:call-template name="authorityConfidenceIcon">
                                        <xsl:with-param name="confidence" select="./@confidence"/>
                                    </xsl:call-template>
                                </xsl:if>
                                <br/>
                            </xsl:for-each>
                        </td>
                    </xsl:if>
                </tr>
            </xsl:when>
            <!-- MMS: Put like fields together to take up less space.  These fields separate from the above due to the lack of @qualifier.  -->
            <xsl:when test="$metadatafieldname='dc.creator' or 
                            $metadatafieldname='dc.subject'">
                <xsl:if test="not(preceding-sibling::dim:field[@element=current()/@element and not(@qualifier)])">
                    <th>
                        <xsl:copy-of select="$metadatafieldname" />
                    </th>
                    <td>
                        <xsl:for-each select="parent::dim:dim/dim:field[@element=current()/@element and not(@qualifier)]">
                            <xsl:copy-of select="./node()"/>
                            <xsl:if test="./@authority and ./@confidence">
                                <xsl:call-template name="authorityConfidenceIcon">
                                    <xsl:with-param name="confidence" select="./@confidence"/>
                                </xsl:call-template>
                            </xsl:if>
                            <br/>
                        </xsl:for-each>
                    </td>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <tr class="ds-table-row">
                    <th>
                        <xsl:copy-of select="$metadatafieldname" />
                    </th>
                    <!-- Ying (via MMS): Parse the values in all other fields to determine whether they contain URLs or mark-up. Turn any URLs into links and any mark-up into mark-up. -->
                    <td>
                        <xsl:choose>
                            <xsl:when test="contains(.,'http://') and $metadatafieldname!='dc.identifier.citation'">
                                <xsl:call-template name="makeLinkFromText"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy>
                                    <xsl:call-template name="parse">
                                        <xsl:with-param name="str" select="./node()"/>
                                        <!-- MMS: Only display link text for citation, don't make it a link. -->
                                        <xsl:with-param name="omit-link">
                                            <xsl:choose>
                                                <xsl:when test="$metadatafieldname='dc.identifier.citation'">1</xsl:when>
                                                <xsl:otherwise>0</xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:copy>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="./@authority and ./@confidence">
                            <xsl:call-template name="authorityConfidenceIcon">
                                <xsl:with-param name="confidence" select="./@confidence"/>
                            </xsl:call-template>
                        </xsl:if>
                    </td>
                </tr>
            </xsl:otherwise>
        </xsl:choose>
        <!-- MMS: Don't output language column. It takes up space and is nearly always 'en' or 'en-US'. -->
    </xsl:template>

    <xsl:template match="dri:document/dri:body/dri:div/dri:div/dri:div[contains(@n,'community-browse') or contains(@n, 'collection-browse')]" priority="1">
     </xsl:template>

        <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
    information is either user-provided bits of post-processing (as in the case of the JavaScript), or
    references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Use the .htaccess and remove these lines to avoid edge case issues.
             More info: h5bp.com/i/378 -->
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

            <!-- Mobile viewport optimized: h5bp.com/viewport -->
            <meta name="viewport" content="width=device-width,initial-scale=1"/>

            <link rel="shortcut icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>lib/images/favicon.ico</xsl:text>
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>lib/images/apple-touch-icon.png</xsl:text>
                </xsl:attribute>
            </link>

            <meta name="Generator">
                <xsl:attribute name="content">
                    <xsl:text>DSpace</xsl:text>
                    <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                    </xsl:if>
                </xsl:attribute>
            </meta>

            <!-- Add stylesheets -->

            <!--TODO figure out a way to include these in the concat & minify-->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$theme-path"/>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <link rel="stylesheet" href="{concat($theme-path, 'styles/main.css')}"/>

            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!--  Add OpenSearch auto-discovery link -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='context']"/>
                        <xsl:text>description.xml</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
            <script>
                //Clear default text of emty text areas on focus
                function tFocus(element)
                {
                if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                }
                //Clear default text of emty text areas on submit
                function tSubmit(form)
                {
                var defaultedElements = document.getElementsByTagName("textarea");
                for (var i=0; i != defaultedElements.length; i++){
                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                defaultedElements[i].value='';}}
                }
                //Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
                function disableEnterKey(e)
                {
                var key;

                if(window.event)
                key = window.event.keyCode;     //Internet Explorer
                else
                key = e.which;     //Firefox and Netscape

                if(key == 13)  //if "Enter" pressed, then disable!
                return false;
                else
                return true;
                }
            </script>

            <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/html5shiv/dist/html5shiv.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/respond/respond.min.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;![endif]--&gt;</xsl:text>

            <!-- Modernizr enables HTML5 elements & feature detects -->
            <script src="{concat($theme-path, 'vendor/modernizr/modernizr.js')}">&#160;</script>

            <!-- Ying added jwplayer and customized scripts.js in the header -->
            <script src="{concat($theme-path, 'scripts/jwplayer/jwplayer.js')}">&#160;</script>
            <!--script src="{concat($theme-path, 'scripts/scripts.js')}">&#160;</script-->

            <!-- Add the title in -->
            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][last()]" />
            <title>
                <xsl:choose>
                    <xsl:when test="starts-with($request-uri, 'page/about')">
                        <i18n:text>xmlui.mirage2.page-structure.aboutThisRepository</i18n:text>
                    </xsl:when>
                    <xsl:when test="not($page_title)">
                        <xsl:text>  </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$page_title/node()" />
                    </xsl:otherwise>
                </xsl:choose>
            </title>

            <!-- Head metadata in item pages -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                              disable-output-escaping="yes"/>
            </xsl:if>

            <!-- Add all Google Scholar Metadata values -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[substring(@element, 1, 9) = 'citation_']">
                <meta name="{@element}" content="{.}"></meta>
            </xsl:for-each>

        </head>
    </xsl:template>


</xsl:stylesheet>
