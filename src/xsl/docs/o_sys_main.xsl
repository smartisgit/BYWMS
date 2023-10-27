<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="1.0">

<xsl:output method="html"/>
<xsl:include href="header.xsl"/>

<xsl:template match="/">
<html>

   <xsl:call-template name="GEN_SUBTITLE">
     <xsl:with-param name="p_subtitle" select="'Integration documentation'"/>
  </xsl:call-template>

<body>

  <xsl:variable name="this_title" select="concat('Event: ',//EVT_ID)"/>

  <xsl:call-template name="GEN_HEADER">
       <xsl:with-param name="p_title" select="$this_title" />
  </xsl:call-template>

  <xsl:call-template name="GEN_NAV_TREE"/>

  <xsl:call-template name="GEN_POST_PROCESSING"/>

</body></html>
</xsl:template>

</xsl:stylesheet>


