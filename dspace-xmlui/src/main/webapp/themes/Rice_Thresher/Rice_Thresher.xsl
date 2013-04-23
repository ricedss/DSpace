<?xml version="1.0" encoding="UTF-8"?>
<!--
	Periodicals.xsl
	Adapted from Adam Mikeal's Periodicals.xsl ((c) 2007 TAMU Libraries) with permission.
	Edited by Max Starkenburg et al.
-->
<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:dri="http://di.tamu.edu/DRI/1.0/"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xlink="http://www.w3.org/TR/xlink/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cds="http://www.rice.edu/CDS"
                version="1.0">

    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:import href="../Rice/Rice.xsl"/>
    <xsl:output indent="yes"/>

	<!-- Set up the key for the Muenchian grouping -->
	<xsl:key name="issues-by-vol" match="cds:issue" use="@vol"/>
	
	<!--
        The document variable is a reference to the top of the original DRI 
        document. This can be useful in situations where the XSL has left
        the original document's context such as after a document() call and 
        would like to retrieve information back from the base DRI document.
    -->
    <xsl:variable name="document" select="/dri:document"/>


	<!-- A collection rendered in the detailView pattern; default way of viewing a collection. -->
    <xsl:template name="collectionDetailView-DIM">
        <div class="detail-view"> 
            <!-- Generate the logo, if present, from the file section -->
            <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='LOGO']"/>
            <!-- Generate the info about the collections from the metadata section -->
            <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim" mode="collectionDetailView-DIM"/>
        </div>
        <!-- List all the volumes and their issues here. -->
        <xsl:apply-templates select="//cds:issue[generate-id(.) = generate-id(key('issues-by-vol', @vol)[1])]"/>
    </xsl:template>


    <!-- Iterate over the <cds:issue> tags and group using the Muenchian method -->
    <xsl:template match="cds:issue">
        <xsl:variable name="search_path" select="$document/dri:meta/dri:pageMeta/dri:metadata[@element='search' and @qualifier='simpleURL']"/>
        <xsl:variable name="query_string" select="$document/dri:meta/dri:pageMeta/dri:metadata[@element='search' and @qualifier='queryField']"/>
        <xsl:variable name="context_path" select="$document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
        <xsl:variable name="collection_handle" select="substring-after($document/dri:meta/dri:pageMeta/dri:metadata[@element='focus' and @qualifier='container'], ':')"/>
        
        <div class="journal-volume-group">
            <xsl:variable name="volnum" select="substring-before(@vol, '(')"/>
            <div>
                <!-- i18n: Volume N -->
                <div class="hiddenfield">
                    <strong>
                        <!-- i18n: Volume N -->
                        <i18n:translate>
                            <i18n:text>xmlui.Periodicals.VolumeNumber</i18n:text>
                            <i18n:param>
                                <xsl:value-of select="@vol"/>
                            </i18n:param>
                        </i18n:translate>
                    </strong>
                    <span class="show-hide" style="display: none;">
                        <xsl:text>[ </xsl:text>
                        <span class="show"><i18n:text>xmlui.Periodicals.show</i18n:text></span>
                        <span class="hide" style="display: none;"><i18n:text>xmlui.Periodicals.hide</i18n:text></span>
                        <xsl:text> ]</xsl:text>
                    </span>
                </div>
            </div>
            <div>
                <div class="hiddenvalue">
                    <xsl:for-each select="key('issues-by-vol', @vol)">
                        <a href="{$context_path}/handle/{@handle}">
                        <!-- i18n: Issue N (YYYY-MM-DD) -->
                                <i18n:translate>
                                    <i18n:text>xmlui.Periodicals.IssueNumberAndDate</i18n:text>
                                    <i18n:param>
                                        <xsl:value-of select="@num"/>
                                    </i18n:param>
                                    <i18n:param>
                                        <xsl:value-of select="@year"/>
                                    </i18n:param>
                                </i18n:translate>
                                <xsl:if test="@name != ''">
                                    <xsl:text> :: </xsl:text>
                                    <xsl:value-of select="@name"/>
                                </xsl:if>
                        </a>
                        |

                    </xsl:for-each>
                </div>
            </div>
        </div>
        
    </xsl:template>

    <!-- Group of templates to hide the search forms and disguise the search results as a browse list (if the search query starts with "series:") -->
    <xsl:template match="dri:div[@n='general-query'][starts-with(/dri:document//dri:value[@type='raw'],'series:')]"/>
    <xsl:template match="dri:p[@n='result-query'][starts-with(/dri:document//dri:value[@type='raw'],'series:')]"/>    
    <xsl:template match="dri:div[@id='aspect.artifactbrowser.SimpleSearch.div.search'][starts-with(/dri:document//dri:value[@type='raw'],'series:')]/dri:head/i18n:text">
        <i18n:text>xmlui.Periodicals.BrowseIssue</i18n:text>
    </xsl:template>
    <xsl:template match="dri:div[@id='aspect.artifactbrowser.SimpleSearch.div.search-results'][/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search' and @qualifier='hideForm']]/dri:head"/>
    
    <!-- Overriding from reusable-overrides.xsl to add the "Series" and "Issue" rows and rearrange several of the later rows. -->
    <xsl:template name="simple-item-record-rows">
        <xsl:apply-templates select="." mode="title"/>
        <xsl:apply-templates select="." mode="alternative-title"/>
        <xsl:apply-templates select="." mode="author"/>
        <xsl:apply-templates select="." mode="translator"/>
        <xsl:apply-templates select="." mode="series"/>
        <xsl:apply-templates select="." mode="issue"/>
        <xsl:apply-templates select="." mode="date"/>
        <xsl:apply-templates select="." mode="abstract"/>
        <xsl:apply-templates select="." mode="citation"/>
        <xsl:apply-templates select="." mode="description"/>
        <xsl:apply-templates select="." mode="uri"/>
    </xsl:template>
    <!-- 'Series' row in simple item record -->
    <xsl:template match="dim:dim" mode="series">
        <xsl:if test="dim:field[@element='relation' and @qualifier='ispartofseries']">
            <tr class="ds-table-row">
                <th><span class="bold"><i18n:text>xmlui.ArtifactBrowser.AdvancedSearch.type_series</i18n:text>:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@element='relation' and @qualifier='ispartofseries']">
                        <xsl:copy-of select="./node()"/>
                        <xsl:if test="count(following-sibling::dim:field[@element='date' and @qualifier='issued']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    <!-- 'Issue' row in simple item record -->
    <xsl:template match="dim:dim" mode="issue">
        <xsl:variable name="query_string" select="$document/dri:meta/dri:pageMeta/dri:metadata[@element='search' and @qualifier='queryField']"/>
        <xsl:variable name="context_path" select="$document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
        <xsl:variable name="collection_handle" select="substring-after($document/dri:meta/dri:pageMeta/dri:metadata[@element='focus' and @qualifier='container'], ':')"/>
        <xsl:variable name="num" select="dim:field[@element='citation' and @qualifier='issueNumber']"/>
        <xsl:variable name="vol" select="dim:field[@element='citation' and @qualifier='volumeNumber']"/>
        <xsl:if test="dim:field[@element='relation' and @qualifier='ispartofseries']">
                    <xsl:choose>
                        <xsl:when test="contains($num, 'Special Issue') ">
                            <tr class="ds-table-row">
                                <th><span class="bold"><i18n:text>xmlui.Periodicals.Issue</i18n:text>:</span></th>
                                <td>
                                    <a href="{$context_path}/handle/{$collection_handle}/search?{$query_string}=series%3A%28%22Volume+{$vol}%2C+,%20+{$num}%22+-%22Page%22%29">Issue <xsl:value-of select="$num"/></a>
                                </td>
                             </tr>

                        </xsl:when>
                        <xsl:when test="contains($num, 'Supplement')">

                        </xsl:when>
                        <xsl:otherwise>
                            <tr class="ds-table-row">
                                 <th><span class="bold"><i18n:text>xmlui.Periodicals.Issue</i18n:text>:</span></th>
                                 <td>
                                    Issue <xsl:value-of select='$num'/>
                                 </td>
                                      </tr>
 
                        </xsl:otherwise>
                    </xsl:choose>
        </xsl:if>
    </xsl:template>


    <!-- Don't display "Unknown author" if none exists. Prevent COinS tooltip when hovering title link. Add "issue date" text before date. -->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM">
        <xsl:variable name="itemWithdrawn" select="@withdrawn" />
        <div class="artifact-description">
            <div class="artifact-title">
                <!-- Moved the COinS span outside of the <a> so that the "title" tooltip text doesn't show up when hovering over the title link. -->
                <xsl:call-template name="COinS" />
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
            <div class="artifact-info">
                <span class="author">
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                            <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                                <xsl:copy-of select="./node()"/>
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
                            <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- If no author was found, don't output "Unknown author". -->
                        <xsl:otherwise/>
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
                            <!-- Insert "issue date" text here. -->
                            <i18n:translate>
                                <i18n:text>xmlui.Periodicals.issuedate</i18n:text>
                                <i18n:param>
                                    <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
                                </i18n:param>
                            </i18n:translate>
                        </span>
                        <xsl:text>)</xsl:text>
                    </span>
                </xsl:if>
            </div>
        </div>
    </xsl:template>


</xsl:stylesheet>
