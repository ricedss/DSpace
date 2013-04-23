<?xml version="1.0" encoding="UTF-8"?>

<!--
    
    Rice.xsl
 
    Description: This provides the Manakin for the Rice University Digital Scholarship Archive. 
                 It's the base XSL that should be imported by other Rice-related Manakins that
                 share the same look and feel but that includes tweaks for a particular community.
                 
    Author: Max Starkenburg
    Author: Ying Jin
    Author: Sid Byrd
    Author: Alexey Maslov (original author of many overridden templates)
    
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
    xmlns:confman="org.dspace.core.ConfigurationManager"
    exclude-result-prefixes="confman">


    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:import href="reusable-new-templates.xsl"/>

    <xsl:import href="reusable-overrides.xsl" />

    <xsl:output indent="yes"/>

    <!-- MMS: Variables defined once for use in multiple places -->
    <xsl:variable name="repositoryURL" select="dri:document/dri:meta/dri:pageMeta/dri:trail[1]/@target"/>
    <xsl:variable name="communityURL" select="dri:document/dri:meta/dri:pageMeta/dri:trail[2]/@target"/>
    <xsl:variable name="contextURL" select="dri:document/dri:meta/dri:pageMeta/dri:trail[position()=last()]/@target"/>
    <xsl:variable name="level">
        <xsl:choose>
            <xsl:when test="dri:document/dri:options/dri:list/dri:list/dri:head/i18n:text='xmlui.ArtifactBrowser.Navigation.head_this_community'">community</xsl:when>
            <xsl:when test="dri:document/dri:options/dri:list/dri:list/dri:head/i18n:text='xmlui.ArtifactBrowser.Navigation.head_this_collection'">collection</xsl:when>
            <xsl:otherwise>repository</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="recent">
        <xsl:choose>
            <xsl:when test="dri:document/dri:body/dri:div/dri:div[contains(@rend,'recent-submission')]/dri:referenceSet/dri:reference">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="numberOfItems"> 
        <xsl:choose>
            <xsl:when test="dri:document/dri:body/dri:div/dri:div[@n='community-view']">
                <xsl:value-of select="document(concat('cocoon:/',dri:document/dri:body/dri:div/dri:div[@n='community-view']/dri:referenceSet/dri:reference/@url))/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='format' and @qualifier='extent']"/>
            </xsl:when>
            <xsl:when test="dri:document/dri:body/dri:div/dri:div[@n='collection-view']">
                <xsl:value-of select="document(concat('cocoon:/',dri:document/dri:body/dri:div/dri:div[@n='collection-view']/dri:referenceSet/dri:reference/@url))/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='format' and @qualifier='extent']"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>
    
    
    
    
      <!-- ============================================
              General page layout, header, footer
         ============================================ -->
    
    
    <!-- MMS: See ../dri2xhtml/structural.xsl for full extensive comments on this template. 
         Copying it here for CSS hooks and to output dri:options before dri:body.  -->
    <xsl:template match="dri:document">
        <html>
            <xsl:call-template name="buildHead"/>
            <xsl:choose>
                <xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
                    <xsl:apply-templates select="dri:body/*"/>
                    <!-- add setup JS code if this is a choices lookup page -->
                    <xsl:if test="dri:body/dri:div[@n='lookup']">
                        <xsl:call-template name="choiceLookupPopUpSetup"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <body>
                        <div id="ds-main">
                            <xsl:call-template name="buildHeader"/>
                            <!-- MMS: wrap another CSS hook around the non-header, non-footer part -->
                            <div id="rice-main">
                                <!-- MMS: Output dri:options before dri:body -->
                                <xsl:apply-templates select="dri:options"/>
                                <xsl:apply-templates select="*[not(self::dri:options)]"/>
                                <!-- MMS: Put a "clear"ing div here. -->
                                <div class="clear"><xsl:text> </xsl:text></div>
                            </div>
                        </div>
                        <xsl:call-template name="buildFooter"/>
                    </body>
                </xsl:otherwise>
            </xsl:choose>
        </html>
    </xsl:template>

    <!-- MMS: Copied from structural.xsl, changed logo mark-up, removed headers, removed profile links, added quick links, remove breadcrumbs (output elsewhere) -->
    <xsl:template name="buildHeader">
        <div id="ds-header">
            <a id="ds-header-logo" href="{$repositoryURL}">
                <xsl:text>&#160;</xsl:text>
            </a>
            <xsl:call-template name="quick-links"/>
            <a class="ds-deposit-your-work" href="http://openaccess.rice.edu/ir-submission-process/">
                <img  src="/themes/Rice/images/deposit_your_work-01.png" alt="deposit_your_work" />
            </a>
        </div>
    </xsl:template>
    
    <!-- MMS: Add Rice-specific links and message.  Add Google Analytics. -->
    <xsl:template name="buildFooter">
        <div id="ds-footer">
            <xsl:call-template name="quick-links"/>
            <p>
                Managed by the <a href="http://library.rice.edu/services/dss/dss-home">Digital Scholarship Services</a> at <a href="http://library.rice.edu">Fondren Library</a>, <a href="http://www.rice.edu">Rice University</a>
            </p>
        </div>
        <!--  adding for Google Analytics ==== YING, move this to head, shouldn't it be in the head??? -->
        <!-- xsl:variable name="host_name" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']" />
        <xsl:if test="contains($host_name,'scholarship.rice.edu')">-->
            <!--  for production server -->
<!--            <script type="text/javascript">
                var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
                document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
            </script>
            <script type="text/javascript">
                try {
                    var pageTracker = _gat._getTracker("UA-1316804-4");
                    pageTracker._trackPageview();
                } catch(err) {}
            </script>
        </xsl:if>  -->
    </xsl:template>

    <!-- MMS: "Home | FAQ | Contact Us" links provided at both top and bottom of page -->
    <xsl:template name="quick-links">
        <ul class="ds-quick-links">
            <li class="first-link">
                <a href="{$repositoryURL}">
                    <!-- i18n: "Home" -->
                    <i18n:text>xmlui.Rice.Home</i18n:text>
                </a>
            </li>
            <li>
                <a href="https://owlspace-ccm.rice.edu/access/wiki/site/91656f53-9adf-45c4-000e-b5072d163d17/faq.html">
                    <!-- i18n: "FAQ" -->
                    <i18n:text>xmlui.Rice.FAQ</i18n:text>
                </a>
            </li>
            <li class="last-link">
                <a href="https://library.rice.edu/services/dss/contact-us-dss">
                    <!-- i18n: "Contact Us" -->
                    <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                </a>
            </li>
        </ul>
    </xsl:template>
    
    
    
    
    
    
    <!-- ============================================
           Main content area (page title and below)
         ============================================ -->
    
    <!-- MMS: Move the breadcrumbs to right above the header. Style the primary header specially. -->
    <xsl:template match="dri:div/dri:head[not(count(ancestor::dri:div) &gt; 1)]" priority="3">
        <!-- MMS: Only output the breadcrumbs if we're at least one level down and we're the primary page header -->
        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) &gt; 1 and parent::dri:div[contains(@rend,'primary')]">
            <ul id="ds-trail">
                <!-- MMS: Don't output the last item in the breadcrumbs, which in most cases is the same as the title. -->
                <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail[position()!=last()]"/>
            </ul>
        </xsl:if>
        <h1>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">
                    <xsl:text>ds-div-head</xsl:text>
                    <!-- MMS: Add a CSS hook to style the primary header on the page, not just any 1-div deep head. -->
                    <xsl:if test="parent::dri:div[contains(@rend,'primary') and not(@n='comunity-browser' and preceding-sibling::dri:div) and not(@n='front-page-search')]">
                        <xsl:text> primary-header</xsl:text>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates />
            <!-- MMS: If we're in a community or collection, output the number of items contained therein. -->
            <xsl:if test="$numberOfItems!=''">
                <span class="number-of-items">
                    <i18n:translate>
                        <i18n:text>xmlui.Rice.ItemsInBrackets</i18n:text>
                        <i18n:param>
                            <xsl:value-of select="$numberOfItems"/>
                        </i18n:param>
                    </i18n:translate>
                </span>
            </xsl:if>
        </h1>
    </xsl:template>

    <!-- MMS: Rearrange this to move the "Recent Submissions" higher in the output, add CSS hooks, and output the context-level browse under the title. -->
    <xsl:template match="dri:div[parent::dri:body][@n='community-home' or @n='collection-home' or starts-with(@n,'browse-by')]" priority="1">
        <xsl:apply-templates select="dri:head"/>
        <div>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">
                    <xsl:text>ds-static-div</xsl:text>
                    <!-- MMS: If there is a "Recent submissions" column, provide CSS hook to add right-margin -->
                    <xsl:if test="$recent='1'">
                        <xsl:text> has-recent</xsl:text>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
            <!-- MMS: Move "Recent Submissions" higher up in the mark-up. -->
            <xsl:apply-templates select="dri:div[contains(@rend,'recent')]"/>
            <!-- MMS: Give the rest of the output a CSS hook. -->
            <div id="content-body">
                <!-- MMS: if there is a context-level browse here, output it here, unless we're at an item page, search page, submission page, etc. -->
                <xsl:if test="dri:div[@n='browse-navigation' or @n='community-search-browse' or @n='collection-search-browse']">
                    <div id="context-browse-search">
                        <h2 class="ds-div-head">
                            <xsl:choose>
                                <xsl:when test="$level='community'">
                                    <!-- i18n: Browse this community by: -->
                                    <i18n:text>xmlui.Rice.BrowseThisCommunityBy</i18n:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- i18n: Browse this collection by: -->
                                    <i18n:text>xmlui.Rice.BrowseThisCollectionBy</i18n:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </h2>
                        <!-- MMS: Reuse contextual browse from "options" area (formerly applied following the repository-level browse) -->
                        <xsl:apply-templates select="ancestor::dri:document/dri:options/dri:list[@n='browse']/dri:list[@n='context']"/>
                        <!-- MMS: Then output the search -->
                        <xsl:apply-templates select="dri:div[contains(@rend,'search-browse')]/dri:div[contains(@rend,'search')]"/>
                    </div>
                </xsl:if>
                <!-- MMS: apply everything but the header and the "Recent Submissions". -->
                <xsl:apply-templates select="*[not(name()='head' or contains(@rend,'recent'))]"/>
            </div>
        </div>
    </xsl:template>
    
    <!-- MMS: Don't output this div as-is (one of its children is specifically applied in another template) -->
    <xsl:template match="dri:div[contains(@rend,'search-browse')]" priority="1" />
    
    <!-- MMS: If in a community, first output the sub-communities and collections, then whatever else was entered by the user(s) managing that community -->
    <xsl:template match="dri:reference[parent::dri:referenceSet/@n='community-view']" mode="detailView">
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="@url"/>
        </xsl:variable>
        <xsl:comment> External Metadata URL: <xsl:value-of select="$externalMetadataURL"/> </xsl:comment>
        <!-- MMS: Add CSS wrapper and reverse order of the two apply-templates -->
        <div id="subcommunity-and-collection-list">
            <xsl:apply-templates />
        </div>
        <xsl:apply-templates select="document($externalMetadataURL)" mode="detailView"/>

        <!-- Ying - add top 10 items for the community -->
         <!--div>
             <h2>Statistics</h2>
         </div>
         <div-->
             <!--xsl:apply-templates select="document('http://localhost/solr/search/select?q=search.resourcetype:2&amp;sort=dc.date.accessioned_dt%20desc&amp;rows=1&amp;fl=dc.date.accessioned_dt&amp;omitHeader=true')"  mode="lastItem"/-->
             <!--xsl:apply-templates select="document('http://localhost/solr/statistics/select?indent=on&amp;version=2.2&amp;omitHeader=true&amp;start=0&amp;rows=10&amp;fl=*%2Cscore&amp;qt=standard&amp;wt=csv&amp;explainOther=&amp;hl.fl=&amp;facet=true&amp;facet.field=owningComm&amp;q=type:0')"  mode="topten"/>

        </div-->

    </xsl:template>
    
    <!-- MMS: If this is the header for a subcommunity list, make it an h2 instead of h3 (copied from structural.xsl) -->
    <xsl:template match="dri:referenceSet/dri:head[i18n:text='xmlui.ArtifactBrowser.CommunityViewer.head_sub_communities']" priority="2">
        <h2>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-list-head</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates />
        </h2>
    </xsl:template>
    
    <!-- MMS: Add extra zero-item CSS hook, and add clearing div under certain circumstances. -->
    <!-- Ying add structMap section to external mets object -->
    <xsl:template match="dri:reference" mode="summaryList">
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="@url"/>
            <xsl:text>?sections=dmdSec,fileSec,structMap</xsl:text>
        </xsl:variable>
        <xsl:comment> External Metadata URL: <xsl:value-of select="$externalMetadataURL"/> </xsl:comment>
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-artifact-item </xsl:text>
                <xsl:choose>
                    <xsl:when test="position() mod 2 = 0">even</xsl:when>
                    <xsl:otherwise>odd</xsl:otherwise>
                </xsl:choose>
                <!-- MMS: If a sub-community or collection has zero items, provide a CSS hook to style those differently -->
                <xsl:if test="document($externalMetadataURL)/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='format' and @qualifier='extent']='0'">
                    <xsl:text> zero-items</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates select="document($externalMetadataURL)" mode="summaryList"/>
            <xsl:apply-templates />
            <!-- MMS: put "clear"ing <div> at the end of dri:rererence elements, since many of them have floating thumbnails,
                 but don't do this for dri:reference elements that list subcommunities and collections (on a community page), 
                 since this will conflict with the floating "Recent submissions".  -->
            <xsl:if test="not(ancestor::dri:div[@n='community-view'])">
                <div class="clear-right"><xsl:text> </xsl:text></div>
            </xsl:if>
        </li>
    </xsl:template>
    
    <!-- MMS: Add the word "Items" after the count. Provide a CSS hook for that text. Copied from DIM-Handler.xsl. -->
    <xsl:template name="collectionSummaryList-DIM">
        <xsl:variable name="data" select="./mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
        <a href="{@OBJID}">
            <xsl:choose>
                <xsl:when test="string-length($data/dim:field[@element='title'][1]) &gt; 0">
                    <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                </xsl:otherwise>
            </xsl:choose>
        </a>
        <xsl:if test="string-length($data/dim:field[@element='format'][@qualifier='extent'][1]) &gt; 0">
            <!-- MMS: Provide a CSS hook to more easily style this text differently. -->
            <span class="item-count">
                <!-- MMS: Output "[N items]" instead of the more ambiguous "[N]" -->
                <i18n:translate>
                    <i18n:text>xmlui.Rice.ItemsInBrackets</i18n:text>
                    <i18n:param>
                        <xsl:value-of select="$data/dim:field[@element='format'][@qualifier='extent'][1]"/>
                    </i18n:param>
                </i18n:translate>
            </span>
        </xsl:if>
    </xsl:template>
    
    <!-- MMS: Add the word "Items" after the count. Provide a CSS hook for that text. Copied from DIM-Handler.xsl. -->
    <xsl:template name="communitySummaryList-DIM">
        <xsl:variable name="data" select="./mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
        <span class="bold">
            <a href="{@OBJID}">
                <xsl:choose>
                    <xsl:when test="string-length($data/dim:field[@element='title'][1]) &gt; 0">
                        <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </span>
        <!--Display community strengths (item counts) if they exist-->
        <xsl:if test="string-length($data/dim:field[@element='format'][@qualifier='extent'][1]) &gt; 0">
            <!-- MMS: Provide a CSS hook to more easily style this text differently. -->
            <span class="item-count">
                <!-- MMS: Output "[N items]" instead of the more ambiguous "[N]" -->
                <i18n:translate>
                    <i18n:text>xmlui.Rice.ItemsInBrackets</i18n:text>
                    <i18n:param>
                        <xsl:value-of select="$data/dim:field[@element='format'][@qualifier='extent'][1]"/>
                    </i18n:param>
                </i18n:translate>
            </span>
        </xsl:if>

        <!--xsl:apply-templates select="document('http://localhost/solr/search/select?q=search.resourcetype:2&amp;sort=dc.date.accessioned_dt%20desc&amp;rows=1&amp;fl=dc.date.accessioned_dt&amp;omitHeader=true')"  mode="lastItem"/-->

    </xsl:template>
    
    


    
    
    
    <!-- ============================================
            Contextual search/browse below header
         ============================================ -->
        
    <!-- MMS: Copied from structural.xsl (match="dri:div[@interactive='yes']") and made specific to "search-browse" interactive div -->
    <xsl:template match="dri:div[@interactive='yes'][parent::dri:div[contains(@rend,'search-browse')]]" priority="2">
        <div id="context-search">
            <form>
                <xsl:call-template name="standardAttributes">
                    <xsl:with-param name="class">ds-interactive-div</xsl:with-param>
                </xsl:call-template>
                <xsl:attribute name="action"><xsl:value-of select="@action"/></xsl:attribute>
                <xsl:attribute name="method"><xsl:value-of select="@method"/></xsl:attribute>
                <xsl:if test="@method='multipart'">
                    <xsl:attribute name="method">post</xsl:attribute>
                    <xsl:attribute name="enctype">multipart/form-data</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="onsubmit">javascript:tSubmit(this);</xsl:attribute>
                <!--For Item Submission process, disable ability to submit a form by pressing 'Enter'-->
                <xsl:if test="starts-with(@n,'submit')">
                    <xsl:attribute name="onkeydown">javascript:return disableEnterKey(event);</xsl:attribute>
                </xsl:if>
                <xsl:for-each select="dri:p[@n='search-query']/dri:field[@type='text']">
                    <!-- MMS: I had wanted to count the characters in the "value" attribute to provide a "size" value, but that doesn't seem possible with the i18n stuff. -->
                    <!-- MMS: Add JS that hides the default value ("Search within this community/collection") if the input is clicked on our tabbed to, 
                              and reverts to the default value if the value left by the user is null. -->
                    <input size="30" i18n:attr="value" onfocus="removeLabel(this,1);" onblur="resurrectLabel(this,1)">
                        <xsl:attribute name="value">
                            <xsl:choose>
                                <xsl:when test="$level='community'">
                                    <!-- i18n: Search within this community -->
                                    <xsl:text>xmlui.Rice.SearchWithinCommunity</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- i18n: Search within this collection -->
                                    <xsl:text>xmlui.Rice.SearchWithinCollection</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:call-template name="fieldAttributes"/>
                    </input>
                </xsl:for-each>
                <xsl:apply-templates select="dri:p[@n='search-query']/dri:field[not(@type='text')]"/>
                <!-- MMS: Truncate the "Within this community/collection" text. -->
                <a href="{dri:p/dri:xref/@target}" class="advanced-search">
                    <!-- i18n: Advanced Search -->
                    <i18n:text>xmlui.ArtifactBrowser.AdvancedSearch.trail</i18n:text>
                </a>
            </form>
        </div>
    </xsl:template>
    
    <!-- MMS: Convert the contextual browse into a series of pipe-separated links instead of list with a header -->
    <xsl:template match="dri:options/dri:list[@n='browse']/dri:list[@n='context']">
        <div id="context-browse">
            <xsl:for-each select="dri:item">
                <xsl:apply-templates />
                <xsl:if test="position()!=last()"> | </xsl:if>
            </xsl:for-each>
        </div>
    </xsl:template>
    
    <!-- MMS: If we're on one of the contextual browse links, highlight that link.
         This might not be very efficient and should be considered for removal if it's slowing things down. -->
    <xsl:template match="dri:xref[ancestor::dri:list[parent::dri:list[@n='browse']]/@n='context']">
        <a>
            <xsl:if test="@target">
                <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@n">
                <xsl:attribute name="name"><xsl:value-of select="@n"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:value-of select="rend"/>
                <xsl:if test="substring-after(@target,'?type=')=substring-after(ancestor::dri:document/dri:body/dri:div[@rend='primary']/@n,'browse-by-')">
                    <xsl:text> selected</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates />
        </a>
    </xsl:template>
    <!-- MMS: Similar to above, if we're on one of the global browse links, highlight that link. -->
    <xsl:template match="dri:xref[ancestor::dri:list[parent::dri:list[@n='browse']]/@n='global']">
        <a>
            <xsl:if test="@target">
                <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@n">
                <xsl:attribute name="name"><xsl:value-of select="@n"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:value-of select="rend"/>
                <xsl:choose>
                    <!-- MMS: Test the community-list link first, or else the second test will always be true due to a lack of '?type=' in the @target's value. -->
                    <xsl:when test="@target='/community-list'">
                        <xsl:if test="ancestor::dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request' and @qualifier='URI']='community-list'">
                            <xsl:text> selected</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="substring-after(@target,'?type=')=substring-after(ancestor::dri:document/dri:body/dri:div[@rend='primary']/@n,'browse-by-')">
                        <xsl:text> selected</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates />
        </a>
    </xsl:template>
    <!-- MMS: Similar to above, if we're on one of the alphabetical links in the browse interface, highlight that link. -->
    <xsl:template match="dri:xref[ancestor::dri:list/@rend='alphabet']">
        <a>
            <xsl:if test="@target">
                <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@n">
                <xsl:attribute name="name"><xsl:value-of select="@n"/></xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:value-of select="rend"/>
                <xsl:if test="contains(ancestor::dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request' and @qualifier='queryString'],concat('starts_with=',substring(substring-after(@target,'starts_with='),1,1)))">
                    <xsl:text> selected</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates />
        </a>
    </xsl:template>
    
    <!-- MMS: For browsing, use label of "Date" instead of "By Issue Date" (applies to both repository-wide and contextual browsing) -->
    <xsl:template match="dri:xref[contains(@target,'dateissued')]/node()">
        <!-- i18n: Date -->
        <i18n:text>xmlui.dri2xhtml.METS-1.0.item-date</i18n:text>
    </xsl:template>
    
    
    
    
    
    
    <!-- ============================================
                     Reference listings
         ============================================ -->
    
    <!-- MMS: Move the preview/icon to come before the item's information in the mark-up (copied from DIM-HandleHandler.xsl with comments removed) -->
    <xsl:template name="itemSummaryList-DIM">
        <xsl:apply-templates select="./mets:fileSec" mode="artifact-preview"/>
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
            mode="itemSummaryList-DIM"/>
    </xsl:template>
    
    <!-- Ying (via MMS): Generate the thumbnail, if present, from the file section -->
    <xsl:template match="mets:fileSec" mode="artifact-preview">
        <xsl:variable name="pfid" select="/mets:METS/mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID" />
        <xsl:choose>
            <xsl:when test="mets:fileGrp/mets:file[@ID=$pfid]/@MIMETYPE='text/xml' and
                /mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='format' and @qualifier='xmlschema']">
                <!-- Ying (via MMS): Present the thumbnail for text, tei or pdf, etc, if present, from the file section -->
                <!-- <xsl:if test="mets:fileGrp[@USE='HTML']/mets:file/mets:FLocat[contains(@xlink:title, 'tei')]"> -->
                <!-- to have this work, you got to setup the mets for summarylist to contain TEXT info -->
                <!-- xsl:if test="mets:fileGrp[@USE='TEXT']" -->
                <div class="artifact-preview">
                    <a href="{ancestor::mets:METS/@OBJID}">
                        <!-- MMS: Use a different image than the TIMEA one. -->
                        <img alt="TEI Thumbnail" src="/themes/Rice/images/text-icon.png" />
                    </a>
                </div>
            </xsl:when>
            <xsl:when test="mets:fileGrp[@USE='THUMBNAIL']">
                <div class="artifact-preview">
                    <xsl:apply-templates select="mets:fileGrp[@USE='THUMBNAIL']/mets:file" mode="thumbnail">
                        <xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"  order="ascending"/>
                    </xsl:apply-templates>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
 
    <!-- MMS: copied for the COinS change and to prevent "Unknown author" from displaying if none of the supported creators/contributors are found -->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM"> 
        <xsl:variable name="itemWithdrawn" select="@withdrawn" />
        <div class="artifact-description">
            <div class="artifact-title">
                <!-- MMS: Moved the COinS span outside of the <a> so that the "title" tooltip text doesn't show up when hovering over the title link. -->
                <xsl:call-template name="COinS"/>
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
                        <!-- MMS: Prevent 'funder' or 'translator' from being counted as an author -->
                        <xsl:when test="dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator')]">
                            <xsl:for-each select="dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator')]">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor'][not(@qualifier='funder') and not(@qualifier='translator')]) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- MMS: Don't display "Unknown Author" if none of the above fields are found. -->
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
                            <xsl:call-template name="displayDate">
                                <xsl:with-param name="iso" select="dim:field[@element='date' and @qualifier='issued']/node()"/>
                            </xsl:call-template>
                        </span>
                        <xsl:text>)</xsl:text>
                    </span>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    




    <!-- ============================================
         Left-hand sidebar (repository browse/search)
         ============================================ -->
    
    <!-- MMS: Only display the browse links from the repository level, not the contextual level (which are displayed elsewhere).
         Add in the repository-wide search here.  Then follow that will all the options related to accounts and admin. -->
    <xsl:template match="dri:options">
        <div id="ds-options">
            <h2>
                <i18n:text>xmlui.Rice.BrowseTheEntireArchive</i18n:text>
            </h2>
            <xsl:apply-templates select="dri:list[@n='browse']/dri:list[@n='global']" mode="nested"/>
            <!-- Special handling of the search box, which is not actually included in
                 the options div, but is instead built from available metadata -->
            <div id="ds-search-option" class="ds-option-set">
                <form method="post" class="navSearch">
                    <xsl:attribute name="action">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                    </xsl:attribute>
                    <!-- i18n: "Search the archive" -->
                    <input class="ds-text-field" type="text" id="nav-search" onfocus="removeLabel(this);" onblur="resurrectLabel(this)" value="xmlui.dri2xhtml.structural.search" i18n:attr="value">
                        <xsl:attribute name="name">
                            <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']"/>
                        </xsl:attribute>
                    </input>
                    <!-- i18n: "Go" -->
                    <input class="ds-button-field " name="submit" type="submit" value="xmlui.general.go" i18n:attr="value"/>
                </form>
                <div class="advanced-search">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='advancedURL']"/>
                        </xsl:attribute>
                        <!-- i18n: Advanced Search -->
                        <i18n:text>xmlui.ArtifactBrowser.AdvancedSearch.trail</i18n:text>
                    </a>
                </div>
            </div>
            <!-- MMS: "My Account" / "Context" / "Administrative" go here -->
            <div id="user-activities">
                <xsl:apply-templates select="*[not(self::dri:list[@n='browse'])]"/>
            </div>
        </div>
    </xsl:template>
    
    <!-- MMS: Strip out the headers and <li>s for the "Browse" lists -->
    <xsl:template match="dri:options/dri:list[@n='browse']/dri:list" priority="3" mode="nested">
        <div>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-option-set</xsl:with-param>
            </xsl:call-template>
            <ul class="ds-simple-list">
                <xsl:apply-templates select="dri:item" mode="nested"/>
            </ul>
        </div>
    </xsl:template>
    
    <!-- Ying: Since we removed all login info from header, add logged-in username to logout link in options. -->
    <xsl:template match="dri:options/dri:list[@n='account']/dri:item/dri:xref[@target='/logout']">
        <a>
            <xsl:if test="@target">
                <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@rend">
                <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
            </xsl:if>
            <xsl:if test="@n">
                <xsl:attribute name="name"><xsl:value-of select="@n"/></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>   
            <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='firstName']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='lastName']"/>
        </a>
    </xsl:template>
    
       
    
    
    
    
    <!-- ============================================
                     "Recently Submitted"
         ============================================ -->
    
    <!-- MMS: For the "Recently Submitted" section, add a CSS hook around it, give it a more explicit header, and add some "See all" links above
         and below the listings (these really just link to the "Browse by Date" listings). -->
    <!-- For using discovery interface, we have to comments this out -->
    <xsl:template match="dri:div[contains(@rend,'recent-submission')]" priority="1">
        <!-- MMS: If this section is empty, don't display the "recent submissions" div at all -->
        <xsl:if test="$recent='1'">
            <!-- MMS: Get a URL for the "See all" links to go use -->
            <xsl:variable name="seeMoreURL" select="concat($contextURL,'/browse?type=dateissued')"/>
            <!-- MMS: CSS hook here -->
            <div id="recent-submissions">
                <!-- MMS: The first "See all" link -->
                <div id="see-all">
                    <xsl:text>(</xsl:text>
                    <a href="{$seeMoreURL}">
                        <!-- i18n: see all -->
                        <i18n:text>xmlui.Rice.SeeAll</i18n:text>
                    </a>
                    <xsl:text>)</xsl:text>
                </div>
               <h2 class="ds-div-head">
                    <!-- MMS: Tell users more explicitly what the recent submissions are part of. -->
                    <xsl:choose>
                        <xsl:when test="$level='community'">
                            <!-- i18n: Recent submissions in this community -->
                            <i18n:text>xmlui.Rice.RecentSubmissionsCommunity</i18n:text>
                        </xsl:when>
                        <xsl:when test="$level='collection'">
                            <!-- i18n: Recent submissions in this collection -->
                            <i18n:text>xmlui.Rice.RecentSubmissionsCollection</i18n:text>
                         </xsl:when>
                         <xsl:otherwise>
                             <i18n:text>xmlui.Rice.RecentSubmissionsArchive</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </h2>
                <div>
                    <xsl:call-template name="standardAttributes">
                        <xsl:with-param name="class">ds-static-div</xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="*[not(name()='head')]"/>
                </div>
                <!-- MMS: The second "See all" link, more explicit than the first, since it's farther from the title -->
                <p class="more">
                    <a href="{$seeMoreURL}">
                        <i18n:translate>
                            <xsl:choose>
                                <xsl:when test="$level='community'">
                                    <!-- i18n: See all {N} items in this community -->
                                    <i18n:text>xmlui.Rice.SeeAllItemsCommunity</i18n:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- i18n: See all {N} items in this collection -->
                                    <i18n:text>xmlui.Rice.SeeAllItemsCollection</i18n:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <i18n:param>
                                <xsl:value-of select="$numberOfItems"/>
                            </i18n:param>
                        </i18n:translate>
                    </a>
                </p>
            </div>
        </xsl:if>
        <!--xsl:variable name="solr-search-url" select="confman:getProperty('discovery', 'search.server')"/>
        <xsl:apply-templates select="document(concat($solr-search-url, '/select?q=search.resourcetype:2&amp;sort=dc.date.accessioned_dt%20desc&amp;rows=1&amp;fl=dc.date.accessioned_dt&amp;omitHeader=true'))"  mode="lastItem"/-->
        <!--xsl:apply-templates select="document('http://localhost/solr/search/select?q=search.resourcetype:2&amp;sort=dc.date.accessioned_dt%20desc&amp;rows=1&amp;fl=dc.date.accessioned_dt&amp;omitHeader=true')"  mode="lastItem"/-->
        <!--xsl:apply-templates select="document('http://localhost/solr/statistics/select?indent=on&amp;version=2.2&amp;start=0&amp;rows=10&amp;fl=*%2Cscore&amp;qt=standard&amp;wt=standard&amp;explainOther=&amp;hl.fl=&facet=true&amp;facet.field=epersonid&amp;q=type:0'"  mode="lastItem"/-->

    </xsl:template>
    
    <!-- MMS: Limit recent submitted list to 3 items (copied from structural.xsl) -->
    <xsl:template match="dri:referenceSet[@type = 'summaryList']" priority="2">
        <xsl:apply-templates select="dri:head"/>
        <!-- Here we decide whether we have a hierarchical list or a flat one -->
        <xsl:choose>
            <xsl:when test="descendant-or-self::dri:referenceSet/@rend='hierarchy' or ancestor::dri:referenceSet/@rend='hierarchy'">
                <ul>
                    <xsl:apply-templates select="*[not(name()='head')]" mode="summaryList"/>
                </ul>
            </xsl:when>
            <xsl:otherwise>
                <ul class="ds-artifact-list">
                    <!-- MMS: If this is the "Recent Submissions" list, only show the first three items -->
                    <xsl:choose>
                        <xsl:when test="@rend='recent-submissions'">
                            <xsl:apply-templates select="*[not(name()='head')][position() &lt; 4]" mode="summaryList"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="*[not(name()='head')]" mode="summaryList"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </ul>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    
    
    
    
    
    
    <!-- ============================================
                   Search/browse result pages
         ============================================ -->
    
    <!-- MMS: Don't output lists that have no children nodes (was showing up in Advanced Search and making some browsers look off). -->
    <xsl:template match="dri:list[@type='form'][not(*)]" />
        
    <!-- MMS: Need a non-table CSS wrapper for the table of search controls above search results -->
    <xsl:template match="dri:table[@n='search-controls']">
        <div id="search-controls">
            <table>
                <xsl:call-template name="standardAttributes">
                    <xsl:with-param name="class">ds-table</xsl:with-param>
                </xsl:call-template>
                <xsl:apply-templates select="dri:row"/>
            </table>
        </div>
    </xsl:template>
    
    <!-- MMS: Add CSS hook around the browse page sorting tools (copied from general dri:p template from structural.xsl, with comments removed) -->
    <xsl:template match="dri:p[dri:field/@type='select']">
        <div>
            <xsl:call-template name="standardAttributes">
                <!-- MMS: Add "sort-options" class around the "Sort By", "Order", and "Results" dropdowns. -->
                <xsl:with-param name="class">ds-paragraph sort-options</xsl:with-param>
            </xsl:call-template>
            <xsl:choose>
                <xsl:when test="child::node()">
                    <xsl:apply-templates />
                </xsl:when>
                <xsl:otherwise>
                    &#160;
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <!-- MMS: Add another link to "Advanced Search" from the page listing the results of a simple search. -->
    <xsl:template match="dri:div[@n='search']/dri:div/dri:p[@rend='button-list']">
        <p>
            <xsl:call-template name="standardAttributes">
                <xsl:with-param name="class">ds-paragraph</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates />
            <a href="advanced-search" class="advanced-search">
                <!-- i18n: Advanced Search -->
                <i18n:text>xmlui.ArtifactBrowser.AdvancedSearch.trail</i18n:text>
            </a>
        </p>
    </xsl:template>
    
    <!-- MMS: Suppress header reading "Search results for Community/Colleciton: [Community/Colleciton Title]", 
         which is distracting and doesn't add much that shouldn't already be apparent. -->
    <xsl:template match="dri:div[@n='search' or @n='advanced-search']/dri:div/dri:head" />
    
    <!-- MMS: Bold sentence that reminds what the search term(s) where. -->
    <xsl:template match="dri:p[i18n:translate[i18n:text='xmlui.ArtifactBrowser.AbstractSearch.result_query']]">
        <p>
            <strong>
                <xsl:call-template name="standardAttributes">
                    <xsl:with-param name="class">ds-paragraph</xsl:with-param>
                </xsl:call-template>
                <xsl:apply-templates />
            </strong>
        </p>
    </xsl:template>
    
    <!-- MMS: Italicize sentence about not returning any results. -->
    <xsl:template match="dri:p[i18n:text='xmlui.ArtifactBrowser.AbstractSearch.no_results']">
        <p>
            <em>
                <xsl:call-template name="standardAttributes">
                    <xsl:with-param name="class">ds-paragraph</xsl:with-param>
                </xsl:call-template>
                <xsl:apply-templates />
            </em>
        </p>
    </xsl:template>
    
    <!-- MMS: Rearrange the elements in the "Now showing items ...", "Previous", and "Next" links -->
    <xsl:template match="@pagination">
        <xsl:param name="position"/>
        <xsl:choose>
            <!-- MMS: "Simple" seems to be the pagination stuff around browse results. -->
            <xsl:when test=". = 'simple'">
                <div class="pagination {$position}">
                    <!-- MMS: Only output this if there are "Previous" and/or "Next" links, since it has a float. -->
                    <xsl:if test="parent::node()[@previousPage or @nextPage]">
                        <div class="pagination-navigation">
                            <xsl:if test="parent::node()/@previousPage">
                                <a class="previous-page-link">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="parent::node()/@previousPage"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.pagination-previous</i18n:text>
                                </a>
                            </xsl:if>
                            <!-- MMS: If there are both "Previous" and "Next" links, separate them with a pipe. -->
                            <xsl:if test="parent::node()[@previousPage and @nextPage]">
                                <span class="pagination-separator">
                                    <xsl:text>|</xsl:text>
                                </span>
                            </xsl:if>
                            <xsl:if test="parent::node()/@nextPage">
                                <a class="next-page-link">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="parent::node()/@nextPage"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.pagination-next</i18n:text>
                                </a>
                            </xsl:if>
                        </div>
                    </xsl:if>
                    <!-- MMS: Only display the "Now showing items ..." text at the top, and display it as a header -->
                    <xsl:if test="$position='top'">
                        <h3 class="pagination-info">
                            <i18n:translate>
                                <i18n:text>xmlui.dri2xhtml.structural.pagination-info</i18n:text>
                                <i18n:param><xsl:value-of select="parent::node()/@firstItemIndex"/></i18n:param>
                                <i18n:param><xsl:value-of select="parent::node()/@lastItemIndex"/></i18n:param>
                                <i18n:param><xsl:value-of select="parent::node()/@itemsTotal"/></i18n:param>
                            </i18n:translate>
                        </h3>
                    </xsl:if>
                </div>
            </xsl:when>
            <!-- MMS: "Masked" seems to be the pagination stuff around search results. -->
            <xsl:when test=". = 'masked'">
                <div class="pagination-masked {$position}">
                    <div class="pagination-navigation">
                        <xsl:if test="not(parent::node()/@firstItemIndex = 0 or parent::node()/@firstItemIndex = 1)">
                            <a class="previous-page-link">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="substring-before(parent::node()/@pageURLMask,'{pageNum}')"/>
                                    <xsl:value-of select="parent::node()/@currentPage - 1"/>
                                    <xsl:value-of select="substring-after(parent::node()/@pageURLMask,'{pageNum}')"/>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.pagination-previous</i18n:text>
                            </a>
                        </xsl:if>
                        <ul class="pagination-links">
                            <xsl:if test="(parent::node()/@currentPage - 4) &gt; 0">
                                <li class="first-page-link">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="substring-before(parent::node()/@pageURLMask,'{pageNum}')"/>
                                            <xsl:text>1</xsl:text>
                                            <xsl:value-of select="substring-after(parent::node()/@pageURLMask,'{pageNum}')"/>
                                        </xsl:attribute>
                                        <xsl:text>1</xsl:text>
                                    </a>
                                    <xsl:text> . . . </xsl:text>
                                </li>
                            </xsl:if>
                            <xsl:call-template name="offset-link">
                                <xsl:with-param name="pageOffset">-3</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="offset-link">
                                <xsl:with-param name="pageOffset">-2</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="offset-link">
                                <xsl:with-param name="pageOffset">-1</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="offset-link">
                                <xsl:with-param name="pageOffset">0</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="offset-link">
                                <xsl:with-param name="pageOffset">1</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="offset-link">
                                <xsl:with-param name="pageOffset">2</xsl:with-param>
                            </xsl:call-template>
                            <xsl:call-template name="offset-link">
                                <xsl:with-param name="pageOffset">3</xsl:with-param>
                            </xsl:call-template>
                            <xsl:if test="(parent::node()/@currentPage + 4) &lt;= (parent::node()/@pagesTotal)">
                                <li class="last-page-link">
                                    <xsl:text> . . . </xsl:text>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="substring-before(parent::node()/@pageURLMask,'{pageNum}')"/>
                                            <xsl:value-of select="parent::node()/@pagesTotal"/>
                                            <xsl:value-of select="substring-after(parent::node()/@pageURLMask,'{pageNum}')"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="parent::node()/@pagesTotal"/>
                                    </a>
                                </li>
                            </xsl:if>
                        </ul>
                        <xsl:if test="not(parent::node()/@lastItemIndex = parent::node()/@itemsTotal)">
                            <a class="next-page-link">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="substring-before(parent::node()/@pageURLMask,'{pageNum}')"/>
                                    <xsl:value-of select="parent::node()/@currentPage + 1"/>
                                    <xsl:value-of select="substring-after(parent::node()/@pageURLMask,'{pageNum}')"/>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.pagination-next</i18n:text>
                            </a>
                        </xsl:if>
                    </div>
                    <!-- MMS: Only display the "Now showing items ..." text at the top, and display it as a header -->
                    <xsl:if test="$position='top'">
                        <h3 class="pagination-info">
                            <i18n:translate>
                                <i18n:text>xmlui.dri2xhtml.structural.pagination-info</i18n:text>
                                <i18n:param><xsl:value-of select="parent::node()/@firstItemIndex"/></i18n:param>
                                <i18n:param><xsl:value-of select="parent::node()/@lastItemIndex"/></i18n:param>
                                <i18n:param><xsl:value-of select="parent::node()/@itemsTotal"/></i18n:param>
                            </i18n:translate>
                        </h3>
                    </xsl:if>
                </div>
             </xsl:when>
        </xsl:choose>
    </xsl:template>


    
    
    
    
    
    <!-- ============================================
                   Item record page (general)
         ============================================ -->
    
    <!-- MMS: Hide the "Show [full/simple] item record" links at the beginning and end of the page and hard-code them in closer to the table. -->
    <xsl:template match="dri:p[contains(@rend,'item-view-toggle')]"/>
    
    <!-- MMS: Add record expander link, as well as "Related links" section if applicable (copied from DIM-Handler.xsl with comments removed).
         Also add CSS wrapper around the table, and reconfigure "Files in this item" section into a called template, since it's also being used by itemDetailView-DIM. -->
    <xsl:template name="itemSummaryView-DIM">
        <xsl:call-template name="file-listing"/>
        <div id="metadata-table">
            <!-- MMS: Put the "Show full item record" link here at the top of the table instead at the top and bottom of everything. -->
            <p class="ds-paragraph item-view-toggle item-view-toggle-top">
                <a href="?show=full"><i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text></a>
            </p>
            <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim" mode="itemSummaryView-DIM"/>
        </div>
        <!-- MMS: Other metadata displayed below the table. -->
        <xsl:call-template name="other-metadata"/>
    </xsl:template>
    
    <!-- MMS: As above, add record expander link, as well as "Related links" section if applicable, add a CSS wrapper, and 
         reconfigure the "Files in this item" section as a called template (copied from DIM-Handler.xsl with comments removed) -->
    <xsl:template name="itemDetailView-DIM">
        <xsl:call-template name="file-listing"/>
        <div id="metadata-table">
            <!-- MMS: Put the "Show simple item record" link here at the top of the table instead at the top and bottom of everything. -->
            <p class="ds-paragraph item-view-toggle item-view-toggle-top">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@OBJID"/>
                    </xsl:attribute>
                    <i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_simple</i18n:text>
                </a>
            </p>
            <xsl:apply-templates select="mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim" mode="itemDetailView-DIM"/>
        </div>
        <!-- MMS: Other metadata displayed below the table. -->
        <xsl:call-template name="other-metadata"/>
    </xsl:template>
    
    <!-- MMS: The "Files in this item" section, which is used by both the itemSummaryView-DIM and itemDetailView-DIM templates -->
    <xsl:template name="file-listing">
        <xsl:choose>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
                    <xsl:with-param name="context" select="."/>
                    <xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
                <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE']"/>
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
    </xsl:template>
    
    <!-- MMS: List the "Usage and Rights", "Related Links", and other license stuff here after the metadata tables -->
    <xsl:template name="other-metadata">
        <!-- MMS: Displays the "Creative Commons License" (hide DSPace deposit license), but should maybe eventually only rely on dc.rights fields. -->
        <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE']"/>
        <!-- Add "Rights and Usage" section for any dc.rights and dc.rights.uri fields -->
        <xsl:if test="descendant::dim:field[@element='rights']">
            <div id="rights-and-usage">
                <h3 class="ds-list-head">
                    <!-- i18n: Rights and Usage -->
                    <i18n:text>xmlui.Rice.RightsAndUsage</i18n:text>
                </h3>
                <ul>
                    <li>
                        <xsl:for-each select="descendant::dim:field[@element='rights']">
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
                    </li>
                </ul>
            </div>
        </xsl:if>
        <!-- MMS: Add section for any "Related links" if they are any pointers to translations, the translated original, a Connexions module, or an "isformatof" field -->
        <xsl:if test="descendant::dim:field[@element='relation'][@qualifier='isreferencedby' or @qualifier='isversionof' or @qualifier='isformatof']">
            <div id="related-links">
                <h3 class="ds-list-head">
                    <!-- i18n: Related Links -->
                    <i18n:text>xmlui.Rice.RelatedLinks</i18n:text>
                </h3>
                <ul>
                    <xsl:for-each select="descendant::dim:field[@element='relation'][@qualifier='isreferencedby' or @qualifier='isversionof' or @qualifier='isformatof']">
                        <li>
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
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
        
    <!-- Ying (via MMS): Doing Zotero/COinS change another way on "Full item record" table.
         MMS: Also, put the table header here instead of on the parent template, so that certain 
         override configurations (see Rice_Shepherd.xsl) don't output it unnecessarily. -->
    <xsl:template match="dim:dim" mode="itemDetailView-DIM">
        <!-- MMS: Give the table a header. -->
        <h3>
            <!-- i18n: Item Metadata -->
            <i18n:text>xmlui.administrative.item.general.option_metadata</i18n:text>
        </h3>
        <table class="ds-includeSet-table">
            <xsl:apply-templates mode="itemDetailView-DIM"/>
        </table>
        <xsl:call-template name="COinS"/>
    </xsl:template>
    
    <!-- MMS: Give "Files in this item" table and header a CSS wrapper.  Change header size.  Change output if item is XML text.  
         Copied from General-Handler.xsl with original comments removed. -->
    <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
        <!-- MMS: Add CSS wrapper here. -->
        <div class="files-in-item">
            <!-- MMS: Make this an <h3> instead of <h2>. -->
            <h3>
                <!-- i18n: Files in this item -->
                <i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text>
            </h3>
            <table class="ds-table file-list">
                <xsl:choose>
                    <!-- If this is an XML text, present a special file table. 
                         MMS: This customization originally put directly in General-Handler.xsl, 
                         but that was not the correct place for it. -->
                    <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/xml' and
                        $context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='format' and @qualifier='xmlschema']">
                        <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]" mode="xml-text">
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="schema">tei</xsl:with-param>
                        </xsl:apply-templates>
                    </xsl:when>
                    <!-- Normal item. -->
                    <xsl:otherwise>
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
                        <xsl:choose>
                            <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
                                <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
                                    <xsl:with-param name="context" select="$context"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="mets:file">
                                    <xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending" />
                                    <xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/>
                                    <xsl:with-param name="context" select="$context"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </table>
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
    
    <!-- Special handling for when there is an XML text item. 
         MMS: This customization originally put directly in General-Handler.xsl, 
         but that was not the correct place for it. -->
    <xsl:template match="mets:file" mode="xml-text">
        <xsl:param name="context"/>
        <xsl:param name="schema"/>
        <tr class="full-book odd">
            <td>
                <xsl:variable name="base" select="substring-after(mets:FLocat[@LOCTYPE='URL']/@xlink:href, 'handle/')" />
                <xsl:variable name="front" select="substring-before($base, '.xml')" />
                <xsl:variable name="seq" select="substring-after($base, '?sequence=')" />
                <xsl:variable name="filename0" select="substring-after($front, '/')" />
                <xsl:variable name="filename" select="substring-after($filename0, '/')" />
                <xsl:variable name="handleslash" select="substring-before($front, $filename)" />
                <xsl:variable name="href">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/jsp/xml/</xsl:text>
                    <xsl:value-of select="$handleslash"/>
                    <xsl:value-of select="$seq"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="$filename"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="$schema"/>
                    <xsl:text>.html</xsl:text>
                </xsl:variable>
                <a href="{$href}">
                    <!-- i18n: View Online -->
                    <i18n:text>xmlui.Rice.ViewOnline</i18n:text>
                </a>
                <xsl:text> </xsl:text>
                <!-- i18n: (witih pages images) -->
                <i18n:text>xmlui.Rice.WithPageImages</i18n:text>
            </td>
        </tr>
        <tr class="mark-up even">
            <td>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                    </xsl:attribute>
                    <!-- i18n: View Markup -->
                    <i18n:text>xmlui.Rice.ViewMarkup</i18n:text>
                </a>
            </td>
        </tr>
    </xsl:template>
    
    <!-- MMS: Copied from DIM-Handler.xsl to output "[N items]" instead of the more ambiguous "[N]". -->
    <xsl:template name="collectionDetailList-DIM">
        <xsl:variable name="data" select="./mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
        <a href="{@OBJID}">
            <xsl:choose>
                <xsl:when test="string-length($data/dim:field[@element='title'][1]) &gt; 0">
                    <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                </xsl:otherwise>
            </xsl:choose>
        </a>
        <xsl:if test="string-length($data/dim:field[@element='format'][@qualifier='extent'][1]) &gt; 0">
            <!-- MMS: Provide a CSS hook to more easily style this text differently. -->
            <span class="item-count">
                <!-- MMS: Output "[N items]" instead of the more ambiguous "[N]" -->
                <i18n:translate>
                    <i18n:text>xmlui.Rice.ItemsInBrackets</i18n:text>
                    <i18n:param>
                        <xsl:value-of select="$data/dim:field[@element='format'][@qualifier='extent'][1]"/>
                    </i18n:param>
                </i18n:translate>
            </span>
        </xsl:if>
        <br/>
        <xsl:choose>
            <xsl:when test="$data/dim:field[@element='description' and @qualifier='abstract']">
                <xsl:copy-of select="$data/dim:field[@element='description' and @qualifier='abstract']/node()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$data/dim:field[@element='description'][1]/node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- MMS: Generate the license information from the file section (copied from General-Handler.xsl), but if there are multiple, put them in the same list -->
    <xsl:template match="mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
        <xsl:if test="not(preceding-sibling::mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE'])">
            <div class="license-info">
                <p><i18n:text>xmlui.dri2xhtml.METS-1.0.license-text</i18n:text></p>
                <ul>
                    <xsl:for-each select="self::*|following-sibling::mets:fileGrp[@USE='CC-LICENSE' or @USE='LICENSE']">
                        <xsl:call-template name="license-list-item"/>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    
    <!-- MMS: Make a list item for each license -->
    <xsl:template name="license-list-item">
        <xsl:if test="@USE='CC-LICENSE'">
            <li><a href="{mets:file/mets:FLocat[@xlink:title='license_text']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_cc</i18n:text></a></li>
        </xsl:if>
        <xsl:if test="@USE='LICENSE'">
            <li><a href="{mets:file/mets:FLocat[@xlink:title='license.txt']/@xlink:href}"><i18n:text>xmlui.dri2xhtml.structural.link_original_license</i18n:text></a></li>
        </xsl:if>
    </xsl:template>
    

    <!-- Ying added for the statistics-->
    <!--xsl:template match="/response/result" mode="topten">
       <xsl:apply-templates/><br />
    </xsl:template-->

    
</xsl:stylesheet>
