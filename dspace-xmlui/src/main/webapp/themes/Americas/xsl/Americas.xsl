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

                      <xsl:call-template name="other-metadata"/>

                      <xsl:if test="$ds_item_view_toggle_url != ''">
                          <xsl:call-template name="itemSummaryView-show-full"/>
                      </xsl:if>
                      <xsl:call-template name="itemSummaryView-collections"/>
      </xsl:template>

        <!-- Customization for Americas: Related links -->
    <xsl:template name="other-metadata">
        <xsl:if test="descendant::dim:field[@element='relation'][@qualifier='isreferencedby' or @qualifier='isversionof' or @qualifier='isformatof' or @qualifier='isbasedon']">
        <h5>
            <!-- i18n: Related Links -->
            <i18n:text>xmlui.Rice.RelatedLinks</i18n:text>
        </h5>
            <ul>
                <xsl:for-each select="descendant::dim:field[@element='relation'][@qualifier='isreferencedby' or @qualifier='isversionof' or @qualifier='isformatof' or @qualifier='isbasedon']">
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
        </xsl:if>
    </xsl:template>

     <!-- MMS: Give "Files in this item" table and header a CSS wrapper.  Change header size.  Change output if item is XML text.
         Copied from General-Handler.xsl with original comments removed. -->


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

</xsl:stylesheet>
