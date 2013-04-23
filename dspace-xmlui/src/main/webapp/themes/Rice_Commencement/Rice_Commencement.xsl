<?xml version="1.0" encoding="UTF-8"?>

<!--
    
    Rice_Commencement.xsl
    
    For overrides in the "Rice University Commencement Programs and Ephemera" community to the base stylesheet (Rice.xsl).
    
    Authors: Ying Jin, Max Starkenburg

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

    <xsl:import href="../Rice/Rice.xsl"/>
    <xsl:output indent="yes"/>

    <!-- MMS: Overriding from reusable-overrides.xsl to add the "Subject" row. -->
    <xsl:template name="simple-item-record-rows">
        <xsl:apply-templates select="." mode="title"/>
        <xsl:apply-templates select="." mode="alternative-title"/>
        <xsl:apply-templates select="." mode="author"/>
        <xsl:apply-templates select="." mode="translator"/>
        <xsl:apply-templates select="." mode="abstract"/>
        <xsl:apply-templates select="." mode="description"/>
        <xsl:apply-templates select="." mode="subject"/>
        <xsl:apply-templates select="." mode="citation"/>
        <xsl:apply-templates select="." mode="uri"/>
        <xsl:apply-templates select="." mode="date"/>
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

    <!-- Ying: Templates for required textarea attributes used if not found in DRI document -->
    <xsl:template name="textAreaCols">
      <xsl:attribute name="cols">80</xsl:attribute>
    </xsl:template>

    <xsl:template name="textAreaRows">
      <xsl:attribute name="rows">10</xsl:attribute>
    </xsl:template>

    <!-- MMS: For certain fields where the text is likely going to be the same, pre-fill some of the forms.
         This has the disadvantages of 1) not being i18n-able, because it seems that even with the
         i18n:attr attribute set to "value", it won't translate the strings at this point, and 
         2) this will therefore create some duplication of text. -->
    <xsl:template match="dri:field[@type='text']" mode="normalField">
        <input>
            <xsl:call-template name="fieldAttributes"/>
            <xsl:attribute name="value">
                <xsl:choose>
                    <xsl:when test="@n='dc_contributor_publisher' or @n='dc_publisher'">
                        <xsl:text>Rice University</xsl:text>
                    </xsl:when>
                    <xsl:when test="@n='dc_language_iso'">
                        <xsl:text>eng</xsl:text>
                    </xsl:when>
                    <xsl:when test="@n='dc_rights'">
                        <xsl:text>Rights to this material belong to Rice University</xsl:text>
                    </xsl:when>
                    <xsl:when test="@n='dc_rights_uri'">
                        <xsl:text>This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License http://creativecommons.org/licenses/by-nc-sa/3.0/</xsl:text>
                    </xsl:when>
                    <xsl:when test="./dri:value[@type='raw']">
                        <xsl:value-of select="./dri:value[@type='raw']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="./dri:value[@type='default']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="dri:value/i18n:text">
                <xsl:attribute name="i18n:attr">value</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates />
        </input>
    </xsl:template>
    
    <!-- MMS: For the dc.digitization.specifications field, pre-fill it with the expected text. -->
    <xsl:template match="dri:field[@type='textarea' and @n='dc_digitization_specifications']" mode="normalField">
        <textarea>
            <xsl:call-template name="fieldAttributes"/>
            <xsl:call-template name="textAreaCols"/>
            <xsl:attribute name="rows">4</xsl:attribute>
            <xsl:apply-templates />
            <i18n:text>xmlui.Submission.submit.DescribeStep.hint.commencement.digitizationspecifications</i18n:text>
        </textarea>
    </xsl:template>

</xsl:stylesheet>
