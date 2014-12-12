<?xml version="1.0" encoding="UTF-8"?>

<!--

    Rice_Centennial.xsl

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
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom">

    <xsl:output indent="yes"/>

    <!-- MMS: COinS change.  Ying (via MMS): Instead of author/publisher info, display full citation.  -->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM">
        <xsl:variable name="itemWithdrawn" select="@withdrawn" />
        <div class="artifact-description">
            <div class="artifact-title">
                <!-- MMS: Moved the COinS span outside of the <a> so that the "title" tooltip text doesn't show up when hovering over the title link. -->
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
            <!-- Ying (via MMS): Instead of displaying the author and publisher information, display a full citation. -->
            <xsl:if test="dim:field[@element='identifier'][@qualifier='citation']">
                <div class="artifact-common">
                    <xsl:copy>
                        <xsl:call-template name="parse">
                            <xsl:with-param name="str" select="dim:field[@element='identifier'][@qualifier='citation'][1]/node()"/>
                            <xsl:with-param name="omit-link">1</xsl:with-param>
                        </xsl:call-template>
                    </xsl:copy>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <!-- Ying: Updated this for our new theme -->
    <xsl:template name="simple-item-record-rows">
  <!--                    <xsl:call-template name="itemSummaryView-DIM-URI"/-->
                      <xsl:call-template name="itemSummaryView-DIM-alternative-title"/>
                      <xsl:call-template name="itemSummaryView-DIM-subtitle"/>
                      <xsl:call-template name="itemSummaryView-DIM-series"/>
                      <xsl:call-template name="itemSummaryView-DIM-authors"/>
                      <xsl:call-template name="itemSummaryView-DIM-translator"/>
                      <xsl:call-template name="itemSummaryView-DIM-abstract"/>
                      <xsl:call-template name="itemSummaryView-DIM-description"/>
                      <xsl:call-template name="itemSummaryView-DIM-date"/>
                      <xsl:call-template name="itemSummaryView-DIM-citation"/>
                      <xsl:if test="$ds_item_view_toggle_url != ''">
                          <xsl:call-template name="itemSummaryView-show-full"/>
                      </xsl:if>
                      <xsl:call-template name="itemSummaryView-collections"/>
      </xsl:template>

     <!-- MMS: Give "Files in this item" table and header a CSS wrapper.  Change header size.  Change output if item is XML text.
         Copied from General-Handler.xsl with original comments removed. -->
    <xsl:template match="mets:fileGrp[@USE='CONTENT']">
        <xsl:param name="context"/>
        <xsl:param name="primaryBitstream" select="-1"/>
        <xsl:param name="xmlFile">
            <xsl:choose>
                <xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/xml' and
                    $context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='format' and @qualifier='xmlschema']">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <!-- MMS: Adding wrapper here. -->
        <div class="file-wrapper row">


               <xsl:choose>
                <!-- If this is an XML text, present a special file table.
                     MMS: This customization originally put directly in General-Handler.xsl,
                     but that was not the correct place for it. -->
                <xsl:when test="$xmlFile='1'">
                    <xsl:apply-templates select="mets:file[@ID=$primaryBitstream]" mode="xml-text">
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="schema">tei</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:when>
                <!-- Normal item. -->
                <xsl:otherwise>
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
        <div class="file-wrapper row">
             <div class="col-xs-6 col-sm-3">
                  <div class="thumbnail">
                <a href="{$href}">
                    <img src="/themes/Americas/a-images/icon_text.gif"/>
                </a>
                      </div>
        </div>
        <div class="col-xs-6 col-sm-7">
             <dl class="file-metadata">
                 <dt>

                    <a href="{$href}">
                        <!-- i18n: View Online -->
                        <i18n:text>xmlui.Rice.ViewOnline</i18n:text>
                    </a>
                    <xsl:text> </xsl:text>
                    <!-- i18n: (witih pages images) -->
                    <i18n:text>xmlui.Rice.WithPageImages</i18n:text>
                    </dt>
        </dl>
        </div>
        <div class="file-link col-xs-6 col-xs-offset-6 col-sm-2 col-sm-offset-0">


                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                    </xsl:attribute>
                    <!-- i18n: View Markup -->
                    <i18n:text>xmlui.Rice.ViewMarkup</i18n:text>
                </a>
        </div>
        </div>
    </xsl:template>



</xsl:stylesheet>
