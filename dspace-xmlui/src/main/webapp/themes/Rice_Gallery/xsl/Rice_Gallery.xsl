<?xml version="1.0" encoding="UTF-8"?>

<!--
    Gallery.xsl

    Implements an image gallery view for Manakin.
-->


<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
		xmlns:dri="http://di.tamu.edu/DRI/1.0/" xmlns:mets="http://www.loc.gov/METS/"
		xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
		xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/TR/xlink/"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
        exclude-result-prefixes="i18n dri mets dim xlink xsl">

  <!--xsl:import href="../../dri2xhtml-alt/dri2xhtml.xsl"/-->
  <xsl:output indent="yes"/>


  <!--  THEME VARIABLES -->
    <!-- bds: todo: check usage and redundancy of these variables -->

    <!-- the URL of this theme, used to make building paths to referenced files easier -->
    <!--xsl:variable name="themePath">
      <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
      <xsl:text>/themes/gallery/</xsl:text>
      </xsl:variable-->

    <!-- serverUrl: path to the  server, up through the port -->
    <xsl:variable name="serverUrl">
      <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
      <xsl:text>://</xsl:text>
      <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
      <xsl:text>:</xsl:text>
      <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
      </xsl:variable>

    <!-- apgeUrl: path to the  server, up through the port -->
    <xsl:variable name="pageUrl">
      <xsl:value-of select="$serverUrl"/>
      <xsl:value-of
	 select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of
	 select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"
	 />
      </xsl:variable>

    <!-- the URL of this theme, used to make building paths to referenced files easier -->
    <xsl:variable name="theme-path">
        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
        <xsl:text>/themes/Rice_Gallery/</xsl:text>
    </xsl:variable>

    <!-- imageTitle: provide a title for the alt tag on the large image for accessability -->
    <xsl:variable name="imageTitle">
        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']"/>
    </xsl:variable>
    
    <xsl:variable name="counter">
      <xsl:value-of select="1"/>
      </xsl:variable>

    <xsl:template name="extraHead-top">
        <!-- pass through some config values to Javascript -->
        <script type="text/javascript">
            var THEME_PATH = "<xsl:value-of select='$theme-path' />";
            var IMAGE_TITLE = "<xsl:value-of select="translate($imageTitle,'&#34;','')"/>";
        </script>

    </xsl:template>

    <!--
        From: General-Handler.xsl
        Blanking out default action.
        -->
    <!--xsl:template match="mets:fileSec" mode="artifact-preview"></xsl:template-->


    <!--xsl:template match="dri:div[@id='aspect.discovery.CollectionRecentSubmissions.div.collection-recent-submission']">
         <script type="text/javascript">
             window.location="discover?filtertype=subject&amp;filter_relational_operator=equals&amp;filter=Events";
         </script>
    </xsl:template-->

    <!-- from discovery.xsl -->
        <xsl:template match="dri:list[@type='dsolist']" priority="2">
        <xsl:apply-templates select="dri:head"/>
            <ul class="ds-artifact-list list-unstyled">
        <xsl:apply-templates select="*[not(name()='head')]" mode="dsoList"/>
            </ul>
    </xsl:template>
     <xsl:template match="dri:listDEBUG/dri:list" mode="dsoList" priority="7">
        <xsl:apply-templates select="dri:head"/>
         <li class="ds-artifact-item">
        <xsl:apply-templates select="*[not(name()='head')]" mode="dsoList"/>
         </li>
    </xsl:template>

    <xsl:template name="itemSummaryList">
        <xsl:param name="handle"/>
        <xsl:param name="externalMetadataUrl"/>

        <xsl:variable name="metsDoc" select="document($externalMetadataUrl)"/>

        <li class="ds-artifact-item ">

            <!--Generates thumbnails (if present)-->
                <div class="artifact-preview">
                    <img class="thumbnail">
                        <xsl:choose>

                        <xsl:when test="$metsDoc/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']">
                            <xsl:attribute name="src">
                                <xsl:value-of select="$metsDoc/mets:METS/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="src">
                                <xsl:value-of select="$theme-path"/>
                                <xsl:text>lib/nothumbnail.png</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>

                    </xsl:choose>
                </img>

                </div>

                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:choose>
                            <xsl:when test="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/@withdrawn">
                                <xsl:value-of select="$metsDoc/mets:METS/@OBJEDIT"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat($context-path, '/handle/', $handle)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                        <xsl:attribute name="class">
                            <xsl:text>fancy-box-link</xsl:text>
                        </xsl:attribute>

                        <xsl:choose>
                            <xsl:when test="dri:list[@n=(concat($handle, ':dc.title.subtitle'))]">
                                <xsl:apply-templates select="dri:list[@n=(concat($handle, ':dc.title.subtitle'))]/dri:item"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                            </xsl:otherwise>
                        </xsl:choose>


                                <!--xsl:for-each select="$metsDoc/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim">
                                    <xsl:call-template name="renderCOinS"/>
                                </xsl:for-each>

                            <xsl:text>&#160;</xsl:text-->

                </xsl:element>

           </li>
    </xsl:template>
    <!--
        From DIM-Handler.xsl
        Changes:
                1. rewrote/reordered to use the Fancybox JQuery library
                2. Removed FancyBox for browselist.

        Generate the info about the item from the metadata section
    -->
    <xsl:template name="itemSummaryList-DIM">

        <xsl:variable name="itemWithdrawn" select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/@withdrawn" />
        <!--
            A -> ItemPage
                DIV#artifact-preview
                    IMG.thumbnail title=TITLE, alt=Thumbnail of TITLE src=THUMBNAIL
        -->
        <a>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="$itemWithdrawn">
                        <xsl:value-of select="@OBJEDIT" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@OBJID" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <div class="artifact-preview">
                <img class="thumbnail">
                    <!-- bds: title attribute gives mouse-over -->
                    <xsl:attribute name="title">
                        <xsl:value-of select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='title'][1]/node()"/>
                    </xsl:attribute>
                    <xsl:attribute name="alt">
                        <xsl:text>Thumbnail of </xsl:text>
                        <xsl:value-of select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='title'][1]/node()"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="//mets:fileGrp[@USE='THUMBNAIL']">
                            <xsl:attribute name="src">
                                <xsl:value-of select="//mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="src">
                                <xsl:value-of select="$theme-path"/>
                                <xsl:text>lib/nothumbnail.png</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                </img>
            </div>
        </a>


        <!-- item title -->
        <!--
            A.fancy-box-link title=TITLE   ->ITEM
                text(TITLE)
            SPAN.publisher-date
                (
                SPAN.date    text(DATE)
                )
        -->
        <a>
            <xsl:variable name="artifactTitle">
                <xsl:value-of select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='title'][1]/node()"/>
            </xsl:variable>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="$itemWithdrawn">
                        <xsl:value-of select="@OBJEDIT" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@OBJID" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:text>fancy-box-link</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='title'][1]/node()"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='title']">
                    <xsl:choose>
                        <xsl:when test="string-length($artifactTitle) >= 40">
                            <xsl:value-of select="substring($artifactTitle,1,40)"/>... </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$artifactTitle"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                </xsl:otherwise>
            </xsl:choose>
        </a>

        <!-- bds: add issue date or submit date depending on the type of browse that is happening -->
        <!--DEBUG   span class="metadata-date">
            <xsl:choose>
                <xsl:when test="$browseMode = '3'">
                    <xsl:text>(accessioned </xsl:text>
                    <span class="dateAccepted">
                        <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='accessioned']/node(),1,10)"/>
                    </span>
                    <xsl:text>)</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="dim:field[@element='date' and @qualifier='issued']">
                        <xsl:text>(</xsl:text>
                        <span class="issued">
                            <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
                        </span>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </span-->
	</xsl:template>

    <!--
        From: DIM-Handler.xsl

        Changes:
            1. add in -line image viewing
            2. reordered elements

        An item rendered in the summaryView pattern. This is the default way to view a DSpace item in Manakin. -->

    <xsl:template name="itemSummaryView-DIM---debug">
        <xsl:if test="//mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='image/jpeg']">
            <script type="text/javascript">
                <xsl:for-each select="//mets:fileGrp[@USE='CONTENT']/mets:file[@MIMETYPE='image/jpeg']">
                    var o = new Object();
                    o.url = "<xsl:value-of select="mets:FLocat/@xlink:href"/>";
                    o.size = <xsl:value-of select="./@SIZE"/>;
                    <!-- Replace double quotes and single quotes with corresponding entities, otherwise Javascript breaks.-->
                    <xsl:variable name="encodedTitle"><!-- 'title' is what METS calls the bitstream file name -->
                        <xsl:call-template name="encode-quotes">
                            <xsl:with-param name="stringToFix" select="mets:FLocat/@xlink:title"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="encodedCaption"><!-- dc.description.abstract -->
                        <xsl:call-template name="encode-quotes">
                            <xsl:with-param name="stringToFix" select="//dim:field[@element='description'][@qualifier='abstract']"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="encodedItemTitle"><!-- dc.title -->
                        <xsl:call-template name="encode-quotes">
                            <xsl:with-param name="stringToFix" select="//dim:field[@element='title']"/>
                        </xsl:call-template>
                    </xsl:variable>

                    o.title = "<xsl:value-of select="$encodedTitle"/>";
                    o.caption = "<xsl:value-of select="$encodedCaption"/>";
                    o.itemTitle = "<xsl:value-of select="$encodedItemTitle"/>";

                    imageJpegArray.push(o);
                </xsl:for-each>
            </script>

            <!-- Photos Div. JavaScript is required to load the images. -->
            <div id="photos">&#160;</div>
        </xsl:if>


	<!-- Generate the info about the item from the metadata section -->
	<xsl:apply-templates
	   select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim" mode="itemSummaryView-DIM"/>

	<!-- Generate the bitstream information from the file section -->
	<xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT']">
	  <xsl:with-param name="context" select="."/>
	  <xsl:with-param name="primaryBitream"
			  select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"
			  />
	  </xsl:apply-templates>

	 <!-- Generate the license information from the file section -->
	 <xsl:apply-templates
	   select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']"/>
  </xsl:template>
  
      <xsl:template name="encode-quotes">
        <xsl:param name="stringToFix"/>   <!-- replace-string is in OSU-local.xsl -->
       <!-- <xsl:variable name="singleQuotesFixed">
         <xsl:call-template name="replace-string">
                <xsl:with-param name="text" select="$stringToFix"/>
                <xsl:with-param name="replace" select="&quot;&apos;&quot;"/>
                <xsl:with-param name="with" select="'&amp;apos;'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="replace-string">
            <xsl:with-param name="text" select="$singleQuotesFixed"/>
            <xsl:with-param name="replace" select="'&quot;'"/>
            <xsl:with-param name="with" select="'&amp;quot;'"/>
        </xsl:call-template>                           -->
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
            <link rel="stylesheet" href="{concat($theme-path, 'lib/gallery.css')}"/>
            <link rel="stylesheet" href="{concat($theme-path, 'lib/jquerytools/scrollable-horizontal.css')}"/>
            <link rel="stylesheet" href="{concat($theme-path, 'lib/jquerytools/scrollable-buttons.css')}"/>

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

            <script src="{concat($theme-path, 'lib/gallery.js')}">&#160;</script>

            <script src="{concat($theme-path, 'lib/thickbox/thickbox.js')}">&#160;</script>

            <script src="{concat($theme-path, 'lib/jquery.jScale.js')}">&#160;</script>

            <script src="{concat($theme-path, 'lib/jquerytools/jquery.tools.min.js')}">&#160;</script>


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
