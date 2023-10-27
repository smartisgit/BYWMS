<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>

<xsl:include href="header.xsl"/>

<xsl:template match="/">

<html>
   <xsl:call-template name="GEN_SUBTITLE">
     <xsl:with-param name="p_subtitle" select="'Integration Documentation'"/>
  </xsl:call-template>

<body>
     <xsl:call-template name="GEN_HEADER">
       <xsl:with-param name="p_title" 
            select="'Stock Status Map'"/>
     </xsl:call-template> 

     <xsl:call-template name="GEN_STKSTS_TABLE"/>
     <xsl:call-template name="GEN_POST_PROCESSING"/>
</body>

</html>
</xsl:template>

<xsl:template name="GEN_STKSTS_TABLE">
  <h2>
  Stock Status Table 
  </h2>
  <div class="indent1">
  <table class="my-table">
    <tr class="my-th">
      <th>Host Stock Status</th>
      <th>Host Location</th>
      <th>WMS Stock Status</th>
    </tr>
    <xsl:apply-templates select="//STK_STS">
    </xsl:apply-templates>
  </table>
  </div>
</xsl:template>

<xsl:template match="STK_STS">
  <tr class="my-td">
    <td><xsl:value-of select="HST_STK_STS"/></td>
    <td><xsl:value-of select="HST_LOC"/></td>
    <td><xsl:value-of select="WMS_STK_STS"/></td>
  </tr>
</xsl:template>


</xsl:stylesheet>
