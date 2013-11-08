<?xml version="1.0" encoding="UTF-8"?>

<!--

    Rice_Shepherd.xsl

    XSLT overrides for the "Shepherd School of Music" community in Rice DSpace, mostly 
    related to changes to the simple item record page, since most of the items in this 
    community are audio recordings and thus need to feature different metadata.

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
    xmlns:atom="http://www.w3.org/2005/Atom">

    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:import href="../Rice/Rice.xsl"/>
    <xsl:output indent="yes"/>
    
    <!-- Utility function for use by other templates below. -->
    <xsl:template name="substring-after-last">
        <xsl:param name="string" />
        <xsl:param name="delimiter" />
        <xsl:choose>
            <xsl:when test="contains($string, $delimiter)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="string"
                        select="substring-after($string, $delimiter)" />
                    <xsl:with-param name="delimiter" select="$delimiter" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Split out a relation.x link into an HTML link with a pretty label -->
    <xsl:template name="relationLink">
        <xsl:param name="field"/>
        <xsl:param name="composer"/>
        <!-- extract whatever's after the last instance of ' (' -->
        <xsl:variable name="rest">
            <xsl:call-template name="substring-after-last">
                <xsl:with-param name="string" select="$field"/>
                <xsl:with-param name="delimiter"><xsl:text> (</xsl:text></xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <!-- If the link is an id, make a query -->
            <xsl:when test="starts-with($rest, 'ssm')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>/search?query='</xsl:text>
                        <xsl:copy-of select="substring-before($rest, ')')"/>
                        <xsl:text>'</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="substring-before($field, concat(' (', $rest))"/>
                </a>
            </xsl:when>
            <!-- If the link is a handle, direct link -->
            <xsl:when test="starts-with($rest, 'http://hdl.handle.net/1911/')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:text>/handle/1911/</xsl:text>
                        <xsl:value-of select="substring-before(substring-after($rest, 'http://hdl.handle.net/1911/'), ')')"/>
                    </xsl:attribute>
                    <xsl:value-of select="substring-before($field, concat(' (', $rest))"/>
                </a>
            </xsl:when>
            <!-- Otherwise, just show it the whole unaltered field as text -->
            <xsl:otherwise>
                <xsl:value-of select="$field" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Instead of the typical simple item record ("Item Metadata" table), if we're on the item page for a "piece", 
         provide a link back to the "performance" that it was from, followed by a table of "Information about this piece".
         If we're on the item page for a "performance", show a table of "Information about this performance", followed by
         links to each of the component "pieces" in the performance (if available). -->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        
        <!-- The most important part is whether this item is a performace or a piece. -->
        <xsl:variable name="itemtype">
            <xsl:choose>
                <xsl:when test="//dim:field[@element='coverage']">
                    <xsl:text>performance</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>piece</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <h3>
            <xsl:choose>
                <xsl:when test="$itemtype='performance'">
                    <!-- i18n: Information about this performance: -->
                    <i18n:text>xmlui.Shepherd.InformationAboutPerformance</i18n:text>
                </xsl:when>
                <xsl:otherwise>
                    <!-- i18n: Information about this piece: -->
                    <i18n:text>xmlui.Shepherd.InformationAboutPiece</i18n:text>
                </xsl:otherwise>
            </xsl:choose>
        </h3>
        <table class="ds-includeSet-table">
            <xsl:call-template name="simple-item-record-rows"/>
        </table>
        <!-- Ying (via MMS): Create a <span> element conforming to the Context Objects in Spans (COinS) specification. -->
        <xsl:call-template name="COinS"/>
        
        
        <!-- Parent performance -->
        <xsl:if test="$itemtype='piece'">
            <h3 class="ds-list-head">
                <!-- i18n: Forms part of the performance: -->
                <i18n:text>xmlui.Shepherd.FormsPartPerformance</i18n:text>
            </h3>
            <ul class="ds-referenceSet-list">
                <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartof']">
                    <li>
                        <xsl:call-template name="relationLink">
                            <xsl:with-param name="field" select="./node()"/>
                        </xsl:call-template>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        
        <!-- Component pieces of the performance. -->
        <xsl:if test="dim:field[@element='relation' and @qualifier='haspart']">
            <h3 class="ds-list-head">
                <xsl:choose>
                    <xsl:when test="count(dim:field[@element='relation' and @qualifier='haspart']) &gt; 0">
                        <!-- i18n: This performance includes the following musical pieces: -->
                        <i18n:text>xmlui.Shepherd.PerformanceIncludesFollowingPieces</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- i18n: This performance includes the following musical piece: -->
                        <i18n:text>xmlui.Shepherd.PerformanceIncludesFollowingPiece</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </h3>
            <ul class="ds-referenceSet-list">
                <xsl:for-each select="dim:field[@element='relation' and @qualifier='haspart']">
                    <li>
                        <xsl:call-template name="relationLink">
                            <xsl:with-param name="field" select="./node()"/>
                        </xsl:call-template>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        
    </xsl:template>

    <!-- MMS: Overriding from reusable-overrides.xsl to add "Composer(s)", "Performed by", "Performance type", "Date recorded", and "Subject" rows 
         and suppress all others except the "Title" and "Citation" rows. -->
    <xsl:template name="simple-item-record-rows">
        <xsl:apply-templates select="." mode="title"/>
        <xsl:apply-templates select="." mode="composer"/>
        <xsl:apply-templates select="." mode="performer"/>
        <xsl:apply-templates select="." mode="performance-type"/>
        <xsl:apply-templates select="." mode="date-recorded"/>
        <xsl:apply-templates select="." mode="citation"/>
        <xsl:apply-templates select="." mode="subject"/>
    </xsl:template>
    <!-- MMS: 'Composer(s)' row in simple item record -->
    <xsl:template match="dim:dim" mode="composer">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='composer']">
            <tr class="ds-table-row">
                <th><span class="bold">
                    <xsl:choose>
                        <xsl:when test="count(dim:field[@element='contributor'][@qualifier='composer']) &gt; 0">
                            <!-- i18n: Composers -->
                            <i18n:text>xmlui.Shepherd.Composers</i18n:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- i18n: Composer -->
                            <i18n:text>xmlui.Shepherd.Composer</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='contributor'][@qualifier='composer']">
                        <xsl:copy-of select="node()"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='composer']) != 0">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- MMS: 'Preformed by' row in simple item record -->
    <xsl:template match="dim:dim" mode="performer">
        <xsl:if test="dim:field[@element='contributor'][@qualifier='performer']">
            <tr class="ds-table-row">
                <th><span class="bold">
                    <!-- i18n: Performed by: -->
                    <i18n:text>xmlui.Shepherd.Performedby</i18n:text>
                </span></th>
                <td>
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
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- MMS: 'Performance type' row in simple item record -->
    <xsl:template match="dim:dim" mode="performance-type">
        <xsl:if test="dim:field[@element='subject'][@qualifier='performancetype']">
            <tr class="ds-table-row">
                <th><span class="bold">
                    <!-- i18n: Performance type: -->
                    <i18n:text>xmlui.Shepherd.Performancetype</i18n:text>
                </span></th>
                <td>
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
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- MMS: 'Date recorded' row in simple item record -->
    <xsl:template match="dim:dim" mode="date-recorded">
        <xsl:if test="dim:field[@element='date' and @qualifier='created']">
            <tr class="ds-table-row">
                <th><span class="bold">
                    <!-- i18n: Date recorded: -->
                    <i18n:text>xmlui.Shepherd.Daterecorded</i18n:text>
                </span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='date' and @qualifier='created']">
                        <xsl:call-template name="displayDate">
                            <xsl:with-param name="iso" select="./node()"/>
                        </xsl:call-template>
                        <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='created']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- MMS: 'Subject' row in simple item record -->
    <xsl:template match="dim:dim" mode="subject">
        <xsl:if test="dim:field[@element='subject'][@qualifier='lcsh']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-subject</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='subject'][@qualifier='lcsh']">
                        <xsl:copy-of select="."/>
                        <xsl:if test="following::dim:field[@element='subject'][@qualifier='lcsh']">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    
    <!-- Overridden from General-Handler.xsl to change the columns in the file table if this is an audio file, 
         change headers for appropriate item type, and add a CSS hook.  
         Removed TEI-related code for simplicity since it won't be used in this theme.  -->
    <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
        <!-- The most important part is whether this item is a performace or a piece. -->
        <xsl:variable name="itemtype">
            <xsl:choose>
                <xsl:when test="//dim:field[@element='coverage']">
                    <xsl:text>performance</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>piece</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- MMS: Add CSS wrapper here. -->
        <div class="files-in-item">
            <xsl:choose>
                <!-- If this is an audio file, present a special file table -->
                <xsl:when test="$itemtype='piece'">
                    <h3>
                        <!-- i18n: Listen to movements in this piece: -->
                        <i18n:text>xmlui.Shepherd.Listentomovements</i18n:text>
                    </h3>
                    <table class="ds-table file-list">
                        <tr class="ds-table-header-row">
                            <th><i18n:text>xmlui.Shepherd.Movement</i18n:text></th>
                            <th><i18n:text>xmlui.Shepherd.Duration</i18n:text></th>
                            <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                            <th><i18n:text>xmlui.Shepherd.Streaming</i18n:text></th>
                            <!-- Display header for 'Description' only if at least one bitstream contains a description -->
                            <xsl:if test="mets:file/mets:FLocat/@xlink:label != ''">
                                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text></th>
                            </xsl:if>
                        </tr>
                        <xsl:apply-templates select="mets:file" mode="shepherd-audio">
                            <xsl:sort select="@GROUPID"/>
                            <xsl:with-param name="context" select="$context"/>
                        </xsl:apply-templates>
                    </table>
                </xsl:when>
                <!-- If this is not an audio file, we assume it's a printed program. -->
                <xsl:otherwise>
                    <h3>
                        <!-- i18n: Printed program for this performance: -->
                        <i18n:text>xmlui.Shepherd.PrintedProgramforPerformance</i18n:text>
                    </h3>
                    <table class="ds-table file-list">
                        <tr class="ds-table-header-row">
                            <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                            <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                            <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                            <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                            <!-- Display header for 'Description' only if at least one bitstream contains a description -->
                            <xsl:if test="mets:file/mets:FLocat/@xlink:label != ''">
                                <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-description</i18n:text></th>
                            </xsl:if>
                        </tr>
                        <xsl:apply-templates select="mets:file">
                            <xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending" />
                            <xsl:sort select="@GROUPID"/>
                            <xsl:with-param name="context" select="$context"/>
                        </xsl:apply-templates>
                    </table>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- MMS: Give "Files in this item" table and header a CSS wrapper.  Change header size.  Copied from DIM-Handler.xsl -->
    <xsl:template match="mets:fileGrp[@USE='ORE']">
        <xsl:variable name="AtomMapURL" select="concat('cocoon:/',substring-after(mets:file/mets:FLocat[@LOCTYPE='URL']//@*[local-name(.)='href'],$context-path))"/>
        <!-- MMS: Add CSS wrapper here. -->
        <div class="files-in-item">
            <!-- MMS: Make this an <h3> instead of <h2>. -->
            <h3>
                <!-- i18n: Files in this item -->
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text>
            </h3>
            <table class="ds-table file-list">
                <thead>
                    <tr class="ds-table-header-row">
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-file</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-size</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-format</i18n:text></th>
                        <th><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-view</i18n:text></th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="document($AtomMapURL)/atom:entry/atom:link[@rel='http://www.openarchives.org/ore/terms/aggregates']">
                        <xsl:sort select="@title"/>
                    </xsl:apply-templates>
                </tbody>
            </table>
        </div>
    </xsl:template>
    
    <!-- If this is the page a piece (with audio file(s)), instead of the data and links for the usual 
         "Files", "Size", "Format", and "View" columns, build the row of data and links for the 
         "Movement", "Duration", "Size", and "Streaming" columns. -->
    <xsl:template match="mets:file" mode="shepherd-audio">
        <xsl:param name="context" select="."/>
        <!-- Get the movement name for use below. -->
        <xsl:variable name="filelabel">
            <xsl:choose>
                <xsl:when test="contains(mets:FLocat[@LOCTYPE='URL']/@xlink:label, '(')">
                    <xsl:value-of select="substring-before(mets:FLocat[@LOCTYPE='URL']/@xlink:label, ' (')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
       <xsl:variable name="streamingfilename">
            <xsl:value-of select="@ID"/>_<xsl:value-of select="mets:FLocat/@xlink:title"/>
        </xsl:variable>
         <!-- Get the duration text for use below. -->
        <xsl:variable name="fileduration">
            <xsl:choose>
                <xsl:when test="contains(mets:FLocat[@LOCTYPE='URL']/@xlink:label, '(')">
                    <xsl:variable name="raw">
                        <xsl:call-template name="substring-after-last">
                            <xsl:with-param name="string" select="mets:FLocat[@LOCTYPE='URL']/@xlink:label"/>
                            <xsl:with-param name="delimiter"><xsl:text> (</xsl:text></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="substring-before($raw, ')')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>--:--</xsl:text>/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tr class="ds-table-row">
            <!-- "Movement" (filelabel) -->
            <td>
                <xsl:choose>
                    <!-- If filesize is 0, that means this is a placeholder file whose only purpose is to provide
                         a place to put descriptive text about why there isn't a real file here instead. -->
                    <xsl:when test="@SIZE='0'">
                        <p>
                            <xsl:value-of select="$filelabel"/>
                        </p>
                    </xsl:when>
                    <xsl:otherwise>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                            </xsl:attribute>
                            <xsl:attribute name="title">
                                <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                            </xsl:attribute>
                            <xsl:value-of select="$filelabel"/>
                        </a>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <!-- "Duration" -->
            <td>
                <!-- If filesize is 0, that means this is a placeholder file, 
                     and fill the rest of the cells with the duration info. -->
                <xsl:if test="@SIZE='0'">
                    <xsl:attribute name="colspan">
                        <xsl:text>3</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$fileduration"/>
            </td>
            <!-- "Size" -->
            <xsl:if test="@SIZE &gt; 0">
                <td>
                    <!-- File size always comes in bytes and thus needs conversion -->
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
                <!-- "Streaming" link(s) -->
                <td>
                    <xsl:choose>
                        <xsl:when test="@MIMETYPE='audio/x-mp3'">
                            <!-- With JWPlayer 6 -->

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
                </td>
            </xsl:if>
        </tr>
    </xsl:template>


</xsl:stylesheet>
