<?xml version="1.0" encoding="UTF-8"?>

<!-- 

    Rice_CTTL.xsl

    This file contains overrides of templates, as commented below, for the 
    CTTL "Web adventures for education" community of the 
    Rice Digital Scholarship archive.
    
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
    
    <xsl:import href="../dri2xhtml.xsl"/>
    <xsl:import href="../Rice/Rice.xsl"/>
    <xsl:output indent="yes"/>

    <!-- override to omit metadata table header-->
    <xsl:template match="dim:dim" mode="itemSummaryView-DIM">
        <table class="ds-includeSet-table">
            <!-- MMS: Reuse the header, table, and COinS code and have other themes only override the simple-item-record-rows template (the guts of the table). -->
            <xsl:call-template name="simple-item-record-rows"/>
        </table>
        <!-- Ying (via MMS): Create a <span> element conforming to the Context Objects in Spans (COinS) specification. -->
        <xsl:call-template name="COinS"/>
    </xsl:template>
    
    <!-- override to omit the entire Files section! -->
    <xsl:template match="mets:fileGrp[@USE='CONTENT']"/>
    
    <!-- only show these fields in simple view-->
    <xsl:template name="simple-item-record-rows">
        <xsl:apply-templates select="." mode="description"/>
        <xsl:apply-templates select="." mode="author"/>
        <xsl:apply-templates select="." mode="uri"/>
    </xsl:template>

    <!-- override URI to provide link to original CTTL online resource -->
    <xsl:template match="dim:dim" mode="uri">
        <xsl:if test="dim:field[@mdschema='nsdl' and @element='identifier' and @qualifier='uri']">
            <tr class="ds-table-row">
                <th><span class="bold">Go to game:</span></th>
                <td>
                    <xsl:for-each select="dim:field[@mdschema='nsdl' and @element='identifier' and @qualifier='uri']">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <img alt="Thumbnail">
                                <xsl:attribute name="src">
                                    <xsl:value-of select="//mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/
                                        mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                </xsl:attribute>
                            </img>
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                            <br/>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>
    


</xsl:stylesheet>
