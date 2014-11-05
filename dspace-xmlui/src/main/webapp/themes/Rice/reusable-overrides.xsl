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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:param name="browser" />

    <!-- ============================================
                          Page header
         ============================================ -->

    <!-- MMS: Overriding from structural.xsl for the sole purpose of parsing dri:metadata[@element='xhtml_head_item'] (original comments removed). -->
    <xsl:template name="buildHead">
	    <xsl:param name="extraGACode" select=""/>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <meta name="Generator">
                <xsl:attribute name="content">
                    <xsl:text>DSpace</xsl:text>
                    <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                    </xsl:if>
                </xsl:attribute>
            </meta>
            
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>
            
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
            
            <script type="text/javascript">
				//Clear default text of empty text areas on focus
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

            
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
                <script type="text/javascript">
                    <xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    &#160;
                </script>
            </xsl:for-each>
            
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
                <script type="text/javascript">
                    <xsl:attribute name="src">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>&#160;</script>
            </xsl:for-each>
            
	        <!-- do each Google Universal Analytics code that is configured, but only if this is the
	        production server. (Due to some stupid parameter collision bug, extra codes are given
	        as 'google.extra' in sitemap.xmap. 'google.analytics' is sitewide, from dspace.cfg) -->
	        <xsl:variable name="host_name" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']" />
	        <xsl:if test="contains($host_name,'scholarship.rice.edu') and /dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
	            <script type="text/javascript">
	                <xsl:text>try {</xsl:text>
	                <xsl:text>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga'); </xsl:text>
	                <xsl:text>ga('create', '</xsl:text>
	                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/>
	                <xsl:text>', 'auto'); ga('send', 'pageview'); </xsl:text>
	                <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='extra']">
	                    <xsl:text>ga('create', '</xsl:text>
	                    <xsl:value-of select="."/>
	                    <xsl:text>', 'auto', {'name':'theme'}); ga('theme.send', 'pageview');</xsl:text>
	                </xsl:for-each>
	                <xsl:text>} catch(err) {}</xsl:text>
	            </script>
	        </xsl:if>

	    <!-- Ying added this key to activate jwplayer analytics -->
	    <!--script type="text/javascript">jwplayer.key="Wntm1vNVaEE9HkzSe42YA5n26se24g2VpQ+cew==";</script-->

            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']" />
            <title>
                <xsl:choose>
                    <xsl:when test="not($page_title)">
                        <xsl:text>  </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$page_title/node()" />
                    </xsl:otherwise>
                </xsl:choose>
            </title>
            
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <!-- Ying (via MMS): Updated this to correct head metadata display in item page. -->
                <xsl:copy>
                    <xsl:call-template name="parse">
                        <xsl:with-param name="str" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"/>
                    </xsl:call-template>
                </xsl:copy>
            </xsl:if>
            
        </head>
    </xsl:template>

    <!-- Overriding from structural.xsl to remove the header resizing tricks being done there. 
         MMS: This had been done in structural.xsl, but that file is not an appropriate place to put customizations. -->
    <xsl:template match="dri:div/dri:head" priority="3">
        <xsl:variable name="head_count" select="count(ancestor::dri:div)"/>
        <xsl:element name="h{$head_count}">
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-div-head</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates />
        </xsl:element>
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
    <xsl:template match="mets:file">
        <xsl:param name="context" select="."/>
        <xsl:variable name="bitstreamurl" select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
        <xsl:variable name="streamingfilename">
            <xsl:value-of select="@ID"/>_<xsl:value-of select="mets:FLocat/@xlink:title"/>
        </xsl:variable>
        <tr>
            <xsl:attribute name="class">
                <xsl:text>ds-table-row </xsl:text>
                <xsl:if test="(position() mod 2 = 0)">even </xsl:if>
                <xsl:if test="(position() mod 2 = 1)">odd </xsl:if>
            </xsl:attribute>
            <td>
                <xsl:choose>
                    <xsl:when test="@MIMETYPE='image/jp2'">
                        <a href="javascript:showJPEG2000Viewer('{$bitstreamurl}')">
                            <xsl:choose>
                                <xsl:when test="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title) > 50">
                                    <xsl:variable name="title_length" select="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title)"/>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,1,15)"/>
                                    <xsl:text> ... </xsl:text>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,$title_length - 25,$title_length)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </xsl:when>
		 <!--   <xsl:when test="@MIMETYPE='audio/x-mp3'">

    -->                        <!-- With JWPlayer 6 -->
<!--
                              <div id="{$streamingfilename}">Loading the player...</div>

                              <script type="text/javascript">


                                jwplayer('<xsl:value-of select="$streamingfilename"/>').setup({

                                playlist: [{

                                sources: [{
                                  file: "rtmp://fldp.rice.edu/vod/mp3:dspaceFLstream/<xsl:value-of select='$streamingfilename'/>"
                                },{
                                  file: "/themes/Rice/streaming/<xsl:value-of select='$streamingfilename'/>"
                                }]
                                }],

                                rtmp: {
                                  bufferlength: 10
                                },
                                primary: "flash",
                                height: 30
                                });
                              </script>

                        </xsl:when>-->
                    <!-- SWB No. This link goes to the actual bitstream; they can stream it from the streaming links.
                         <xsl:when test="@MIMETYPE='audio/x-mp3'">
                         <a href="javascript:streamingIt('win', '{$streamingfilename}', '{$streamingfilename}')">
                         <xsl:choose>
                         <xsl:when test="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title) > 50">
                         <xsl:variable name="title_length" select="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title)"/>
                         <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,1,15)"/>
                         <xsl:text> ... </xsl:text>
                         <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,$title_length - 25,$title_length)"/>
                         </xsl:when>
                         <xsl:otherwise>
                         <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                         </xsl:otherwise>
                         </xsl:choose>
                         </a>
                         </xsl:when> -->
                    <!--xsl:when test="@MIMETYPE='video/x-ms-wvx'">
                        <a href="javascript:streamingIt('win', '{$streamingfilename}', '{$streamingfilename}')">
                            <xsl:choose>
                                <xsl:when test="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title) > 50">
                                    <xsl:variable name="title_length" select="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title)"/>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,1,15)"/>
                                    <xsl:text> ... </xsl:text>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,$title_length - 25,$title_length)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </xsl:when>
                    <xsl:when test="@MIMETYPE='video/vnd.rn-realvideo'">
                        <a href="javascript:streamingIt('real', '{$streamingfilename}', '{$streamingfilename}')">
                            <xsl:choose>
                                <xsl:when test="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title) > 50">
                                    <xsl:variable name="title_length" select="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title)"/>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,1,15)"/>
                                    <xsl:text> ... </xsl:text>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,$title_length - 25,$title_length)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </xsl:when>
                    <xsl:when test="@MIMETYPE='video/quicktime'">
                        <a href="javascript:streamingIt('qt', '{$streamingfilename}', '{$streamingfilename}')">
                            <xsl:choose>
                                <xsl:when test="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title) > 50">
                                    <xsl:variable name="title_length" select="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title)"/>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,1,15)"/>
                                    <xsl:text> ... </xsl:text>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,$title_length - 25,$title_length)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </xsl:when-->

                    <xsl:otherwise>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <xsl:attribute name="title">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <!--xsl:when test="mets:FLocat[@LOCTYPE='URL']/@xlink:label">
                                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                                </xsl:when-->
                                <xsl:when test="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title) > 50">
                                    <xsl:variable name="title_length" select="string-length(mets:FLocat[@LOCTYPE='URL']/@xlink:title)"/>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,1,15)"/>
                                    <xsl:text> ... </xsl:text>
                                    <xsl:value-of select="substring(mets:FLocat[@LOCTYPE='URL']/@xlink:title,$title_length - 25,$title_length)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <!-- Original comment: File size always comes in bytes and thus needs conversion -->
            <td>
                <xsl:choose>
                    <xsl:when test="@SIZE &lt; 1000">
                        <xsl:value-of select="@SIZE"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="@SIZE &lt; 1000000">
                        <xsl:value-of select="substring(string(@SIZE div 1000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
                    </xsl:when>
                    <xsl:when test="@SIZE &lt; 1000000000">
                        <xsl:value-of select="substring(string(@SIZE div 1000000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring(string(@SIZE div 1000000000),1,5)"/>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <!-- Original comment: Currently format carries forward the mime type. In the original DSpace, this
                 would get resolved to an application via the Bitstream Registry, but we are
                 constrained by the capabilities of METS and can't really pass that info through. -->
            <td><xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                        mets:file[@GROUPID=current()/@GROUPID]">

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
<!--                            <xsl:when test="@MIMETYPE='audio/x-mp3'">
                                <a class="image-link" href="javascript:streamingIt('win', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="Thumbnail">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                                mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                        </xsl:attribute>
                                    </img>
                                </a>
                            </xsl:when> 
                            <xsl:when test="@MIMETYPE='video/x-ms-wvx'">
                                <a class="image-link" href="javascript:streamingIt('win', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="Thumbnail">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                                mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                        </xsl:attribute>
                                    </img>
                                </a>
                            </xsl:when>
                            <xsl:when test="@MIMETYPE='video/vnd.rn-realvideo'">
                                <a class="image-link" href="javascript:streamingIt('real', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="Thumbnail">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                                mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                        </xsl:attribute>
                                    </img>
                                </a>
                            </xsl:when>
                            <xsl:when test="@MIMETYPE='video/quicktime'">
                                <a class="image-link" href="javascript:streamingIt('qt', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="Thumbnail">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                                mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                        </xsl:attribute>
                                    </img>
                                </a>
                            </xsl:when>-->

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
				height: 180,
				width: 320
		

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
                                height: 30
                                });
                              </script>

                        </xsl:when>

			    

                            <xsl:otherwise>
                                <a class="image-link">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                    <img alt="Thumbnail">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                                mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                        </xsl:attribute>
                                    </img>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="@MIMETYPE='image/jp2'">
                                <a href="javascript:showJPEG2000Viewer('{$bitstreamurl}')">
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                                </a>
                            </xsl:when>
<!--                            <xsl:when test="@MIMETYPE='audio/x-mp3'">
                                <a href="javascript:streamingIt('win', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="WMP Logo" src="/themes/Rice/images/wmp-logo.png" />                                
                                </a>
                                <a href="javascript:streamingIt('real', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="Real Logo" src="/themes/Rice/images/real-logo.png" />
                                </a>
                            </xsl:when> 
                            <xsl:when test="@MIMETYPE='video/x-ms-wvx'">
                                <a href="javascript:streamingIt('win', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="WMP Logo" src="/themes/Rice/images/wmp-logo.png" />
                                </a>
                            </xsl:when>
                            <xsl:when test="@MIMETYPE='video/vnd.rn-realvideo'">
                                <a href="javascript:streamingIt('real', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="Real Logo" src="/themes/Rice/images/real-logo.png" />
                                </a>
                            </xsl:when>
                            <xsl:when test="@MIMETYPE='video/quicktime'">
                                <a href="javascript:streamingIt('qt', '{$streamingfilename}', '{$streamingfilename}')">
                                    <img alt="Quicktime Logo" src="/themes/Rice/images/quick-logo.png" />
                                </a>
                            </xsl:when> -->
                    <!-- Ying added this for mp4 streaming -->
                    <xsl:when test="@MIMETYPE='video/mp4'">
                      <!--html 5 only-->

                        <!-- "Video For Everybody" http://camendesign.com/code/video_for_everybody -->
                        <!--xsl:variable name="fullurl" select="exec(concat('javascript:getfullURL(',$bitstreamurl,')'))"/-->

<!--                     <xsl:if test="$browser='non-firefox'">                                                                                                                                                                            
                            <video controls="controls" width="640" height="360">                                                                                                                                                           
                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                           
                                <source src="http://scholarship.rice.edu/{$bitstreamurl}" type="video/mp4"/>                                                                                                                               
                                <object type="application/x-shockwave-flash" data="http://player.longtailvideo.com/player.swf" width="640" height="360">                                                                                   
                                    <param name="movie" value="http://player.longtailvideo.com/player.swf" />                                                                                                                              
                                    <param name="allowFullScreen" value="true" />                                                                                                                                                          
                                    <param name="wmode" value="transparent" />                                                                                                                                                             
                                    <param name="flashVars" value="controlbar=over&amp;file=http%3A%2F%2Fscholarship.rice.edu%2F{$bitstreamurl}" />                                                                                        
                                </object>                                                                                                                                                                                                  
                            </video>                                                                                                                                                                                                       
                            <p>                                                                                                                                                                                                            
                                <strong>Download video:</strong> <a href="http://scholarship.rice.edu/{$bitstreamurl}">MP4 format</a>                                                                                                      
                            </p>                                                                                                                                                                                                           
                        </xsl:if>                                                                                                                                                                                                          
                        <xsl:if test="$browser = 'firefox'">                                                                                                                                                                               
                                <object type="application/x-shockwave-flash" data="http://player.longtailvideo.com/player.swf" width="640" height="360">                                                                                   
                                    <param name="movie" value="http://player.longtailvideo.com/player.swf" />                                                                                                                              
                                    <param name="allowFullScreen" value="true" />                                                                                                                                                          
                                    <param name="wmode" value="transparent" />                                                                                                                                                             
                                    <param name="flashVars" value="controlbar=over&amp;file=http%3A%2F%2Fscholarship.rice.edu%2F{$bitstreamurl}" />                                                                                        
                                </object>                                                                                                                                                                                                  
                                                                                                                                                                                                                                           
                            <p>                                                                                                                                                                                                            
                                <strong>Download video:</strong> <a href="http://scholarship.rice.edu/{$bitstreamurl}">MP4 format</a>                                                                                                      
                            </p>                                                                                                                                                                                                           
                        </xsl:if>                                                                                                                                                                                                          
                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                           
--><!--                                                                                                                                                                                                                                       
file: "rtmp://fldp.rice.edu/vod/mp4:dspaceFLstream/<xsl:value-of select='$streamingfilename'/>"                                                                                                                                            
                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                           
    playlist: [{                                                                                                                                                                                                                           
                                                                                                                                                                                                                                           
        sources: [{                                                                                                                                                                                                                        
                          file: "rtmp://fldp.rice.edu/vod/mp4:dspaceFLstream/video.mp4"                                                                                                                                                    
        },{                                                                                                                                                                                                                                
            file: "http://scholarship.rice.edu/<xsl:value-of select='$bitstreamurl'/>"                                                                                                                                                     
        }]                                                                                                                                                                                                                                 
    }],                                                                                                                                                                                                                                    
    height: 360,                                                                                                                                                                                                                           
    primary: "flash",                                                                                                                                                                                                                      
    width: 640                                                                                                                                                                                                                             
-->



                        <!-- with JWPlayer 6 -->
		      <xsl:variable name="mp4thumb" select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                                            mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/> 

                        <div id="{$streamingfilename}">Loading the player...</div>
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
			  height: 180,
			  width: 320
			  
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
                                height: 30
                                });
                              </script>

                        </xsl:when>

                            <xsl:otherwise>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-viewOpen</i18n:text>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <!-- Original comment: Display the contents of 'Description' as long as at least one bitstream contains a description -->
            <xsl:if test="$context/mets:fileSec/mets:fileGrp[@USE='CONTENT']/mets:file/mets:FLocat/@xlink:label != ''">
                <td>
                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                </td>
            </xsl:if>
        </tr>
    </xsl:template>
    
    
    
    <!-- ============================================
            Item record page (simple record table)
         ============================================ -->
    
    <!-- MMS: Refactor this template so that just the basic header, table structure, and COinS change 
         are done here, and the rows of metadata are each done in their own template for easy omission, 
         reordering, addition, reuse, and overriding by other themes/Manakins that pull in this XSL.
         In all the rows, I've used <th> instead of <td> for the field labels.  
         I've also removed odd/even class determination (to let JS do that instead of XSL). -->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <!-- MMS: Give the table a header. -->
        <h3>
            <!-- i18n: Item Metadata -->
            <i18n:text>xmlui.administrative.item.general.option_metadata</i18n:text>
        </h3>
        <table class="ds-includeSet-table">
            <!-- MMS: Reuse the header, table, and COinS code and have other themes only override the simple-item-record-rows template (the guts of the table). -->
            <xsl:call-template name="simple-item-record-rows"/>
        </table>
        <!-- Ying (via MMS): Create a <span> element conforming to the Context Objects in Spans (COinS) specification. -->
        <xsl:call-template name="COinS"/>
    </xsl:template>
    
    <xsl:template name="simple-item-record-rows">
        <xsl:apply-templates select="." mode="title"/>
        <xsl:apply-templates select="." mode="alternative-title"/>
        <xsl:apply-templates select="." mode="author"/>
        <xsl:apply-templates select="." mode="keyword"/>
        <xsl:apply-templates select="." mode="abstract"/>
        <xsl:apply-templates select="." mode="description"/>
        <xsl:apply-templates select="." mode="citation"/>
        <xsl:apply-templates select="." mode="uri"/>
        <xsl:apply-templates select="." mode="date"/>
        <xsl:apply-templates select="." mode="doi"/>

    </xsl:template>
    
    <!-- MMS: 'Title' row in simple item record -->
    <xsl:template match="dim:dim" mode="title">
        <tr class="ds-table-row">
            <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-title</i18n:text>: </span></th>
            <td>
                <xsl:choose>
                    <xsl:when test="dim:field[@element='title'][not(@qualifier)]">
                        <xsl:for-each select="dim:field[@element='title'][not(@qualifier)]">
                            <!-- Ying (via MMS): Parse the value so that any HTML is produced. -->
                            <xsl:copy>
                                <xsl:call-template name="parse">
                                    <xsl:with-param name="str" select="./node()"/>
                                </xsl:call-template>
                            </xsl:copy>
                            <xsl:if test="following-sibling::dim:field[@element='title'][not(@qualifier)]">
                                <xsl:text>; </xsl:text>
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- MMS: Add a CSS hook to give this case a distinguished look. -->
                        <span class="untitled"><i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text></span>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
    
    <!-- MMS: 'Alternative Title' row in simple item record -->
    <xsl:template match="dim:dim" mode="alternative-title">
        <!-- Alternative Title -->
        <xsl:if test="dim:field[@element='title'][@qualifier='alternative']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.Rice.Alttitle</i18n:text>:</span></th>
                <td>
                    <xsl:copy-of select="dim:field[@element='title'][@qualifier='alternative']"/>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- MMS: 'Author' row in simple item record -->
    <xsl:template match="dim:dim" mode="author">
        <!-- MMS: Don't let dc.contributor.funder or .translator count as an author. -->
        <xsl:if test="dim:field[@element='creator'] or dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator')]">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-author</i18n:text>:</span></th>
                <td>
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
                        <!-- MMS: Don't let dc.contributor.funder or .translator count as an author. -->
                        <xsl:when test="dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator')]">
                            <xsl:for-each select="dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator')]">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator')]) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- YJ: 'Subject Keywords' row in simple item record -->
    <xsl:template match="dim:dim" mode="keyword">
        <xsl:if test="dim:field[@element='subject'][@qualifier='keyword']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-keyword</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='subject'][@qualifier='keyword']">
                        <span>
                            <xsl:copy-of select="node()"/>
                        </span>
                        <xsl:if test="count(following-sibling::dim:field[@element='subject'][@qualifier='keyword']) != 0">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- MMS: 'Translator' row in simple item record -->
    <xsl:template match="dim:dim" mode="translator">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='translator']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.Rice.Translator</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='contributor'][@qualifier='translator']">
                        <xsl:copy-of select="node()"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='translator']) != 0">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- MMS: 'Abstract' row in simple item record -->
    <xsl:template match="dim:dim" mode="abstract">
        <xsl:if test="dim:field[@element='description' and @qualifier='abstract']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text>:</span></th>
                <td>
                    <!-- MMS: removed <hr/> that preceded multiple abstracts. -->
                    <xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
                        <!-- Ying (via MMS): Parse the value so that any HTML is produced. -->
                        <xsl:copy>
                            <xsl:call-template name="parse">
                                <xsl:with-param name="str" select="./node()"/>
                            </xsl:call-template>
                        </xsl:copy>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and @qualifier='abstract']) != 0">
                            <hr class="metadata-seperator"/>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- MMS: removed <hr/> that followed multiple abstracts. -->
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- MMS: 'Description' row in simple item record -->
    <xsl:template match="dim:dim" mode="description">
        <xsl:if test="dim:field[@element='description' and not(@qualifier)]">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-description</i18n:text>:</span></th>
                <td>
                    <!-- MMS: removed <hr/> that preceded multiple descriptions. -->
                    <xsl:for-each select="dim:field[@element='description' and not(@qualifier)]">
                        <!-- Ying (via MMS): Parse the value so that any HTML is produced. -->
                        <xsl:copy>
                            <xsl:call-template name="parse">
                                <xsl:with-param name="str" select="./node()"/>
                            </xsl:call-template>
                        </xsl:copy>
                        <xsl:if test="count(following-sibling::dim:field[@element='description' and not(@qualifier)]) != 0">
                            <hr class="metadata-seperator"/>
                        </xsl:if>
                    </xsl:for-each>
                    <!-- MMS: removed <hr/> that followed multiple descriptions. -->
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- MMS: 'Citation' row in simple item record -->
    <xsl:template match="dim:dim" mode="citation">
        <xsl:if test="dim:field[@element='identifier'][@qualifier='citation']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-citation</i18n:text>:</span></th>
                <td>
                    <!-- MMS: Parse citation so that any HTML is produced, but skip making an <a> for the URL, 
                         since it's one extra link on that page potentially confusing users. -->
                    <xsl:copy>
                        <xsl:call-template name="parse">
                            <xsl:with-param name="str" select="dim:field[@element='identifier'][@qualifier='citation'][1]/node()"/>
                            <xsl:with-param name="omit-link" select="1"/>
                        </xsl:call-template>
                    </xsl:copy>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- MMS: 'URI' row in simple item record -->
    <xsl:template match="dim:dim" mode="uri">
        <xsl:if test="dim:field[@element='identifier' and @qualifier='uri']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-uri</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='uri']">
                        <!-- MMS: Don't make the URL a link, since it's confusing for users to click on a link and not go anywhere. -->
                        <xsl:copy-of select="./node()"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- YJ: 'DOI' row in simple item record -->
    <xsl:template match="dim:dim" mode="doi">
        <xsl:if test="dim:field[@element='identifier' and @qualifier='doi']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-doi</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='identifier' and @qualifier='doi']">
                        <!-- MMS: Don't make the URL a link, since it's confusing for users to click on a link and not go anywhere. -->
                        <xsl:copy-of select="./node()"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='doi']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
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

    <!-- MMS: 'Date' row in simple item record -->
    <xsl:template match="dim:dim" mode="date">
        <xsl:if test="dim:field[@element='date'][@qualifier='issued']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='date' and @qualifier='issued']">
                        <xsl:call-template name="displayDate">
                            <xsl:with-param name="iso" select="./node()"/>
                        </xsl:call-template>
                        <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
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

</xsl:stylesheet>
