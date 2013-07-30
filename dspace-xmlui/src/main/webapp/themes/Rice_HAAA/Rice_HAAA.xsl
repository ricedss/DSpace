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

    <!-- copied from Rice.xsl but with a different Google Analytics account number -->
    <xsl:template name="buildFooter">
        <div id="ds-footer">
            <xsl:call-template name="quick-links"/>
            <p>
                Managed by the <a href="http://library.rice.edu/services/dss/dss-home">Digital Scholarship Services</a> at <a href="http://library.rice.edu">Fondren Library</a>, <a href="http://www.rice.edu">Rice University</a>
            </p>
        </div>
        <!--  adding for Google Analytics -->
        <xsl:variable name="host_name" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']" />
        <xsl:if test="contains($host_name,'scholarship.rice.edu')">
            <!--  for production server -->
            <script type="text/javascript">
                var _gaq = _gaq || [];
                _gaq.push(['_setAccount', 'UA-37697972-1']);
                _gaq.push(['_setDomainName', 'rice.edu']);
                _gaq.push(['_setAllowLinker', true]);
                _gaq.push(['_trackPageview']);
                
                (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
                })();
            </script>        
        </xsl:if>
    </xsl:template>
    
    
    <!-- ============================================                                                                                                                                                 
                     Reference listings                                                                                                                                                               
         ============================================ -->

    <!-- Ying (via MMS): Find the first thumbnail to display in summary list page. -->
    <xsl:template match="mets:fileGrp[@USE='THUMBNAIL']/mets:file" mode="thumbnail">
        <xsl:if test="position()=2">
            <a href="{ancestor::mets:METS/@OBJID}">
                <img alt="Thumbnail">
                    <xsl:attribute name="src">
                        <xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:href" />
                    </xsl:attribute>
                </img>
            </a>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
