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
 <xsl:call-template name="GEN_HEADER">
       <xsl:with-param name="p_title" 
            select="concat(//IFD_ID,'|',//IFD_VER)"/>
 </xsl:call-template>

<!-- Generate Navigation Tree -->
<xsl:call-template name="GEN_NAV_TREE"/>

<!-- Generate Event Data -->
<xsl:call-template name="GEN_TRG_EVENT_DATA"/>

<!--
        Generate Table Data
-->
<xsl:apply-templates select="//TAB"/>

<!--
    Generate RIFD Mapping Information  
-->
<xsl:call-template name="GEN_MAPPINGS_DATA">
</xsl:call-template>

<xsl:call-template name="GEN_POST_PROCESSING"/>

</body></html>
</xsl:template>


<xsl:template name="GEN_TRG_EVENT_DATA">
  <xsl:variable name="this_event" select="//IFD_DEF/Event/EVT_ID"/>
  <a name="{$this_event}"></a>

  <h2>
  Event: <xsl:value-of select="$this_event"/>
  </h2>

  <div class="indent1">
    <b>Event Validation: </b> <PRE><xsl:value-of select="//IFD_DEF/EVENT_VALIDATION"/></PRE>
  </div>

</xsl:template>

<xsl:template match="TAB">

  <xsl:variable name="this_rifd_id" select="IFD_SEG_ID"/>
  <a name="{$this_rifd_id}"></a>
  <h2>
  Table: <xsl:value-of select="concat(SCHEMA, '.', TABLE_NAME)"/>
  </h2>

  <div class="indent1">
    <b>Trigger Action: </b> <xsl:value-of select="TRIGGERING_ACTION"/>
  </div>

  <div class="indent1">
    <b>Event Algorithm: </b>
  </div>
  <div class="indent2">
    <pre><xsl:value-of select="EVT_ARG_ALGORITHM"/></pre>
  </div>

  <div class="indent1">
     <b>Table Columns: </b>
  </div>

  <div class="indent1">
  <table class="my-table">
    <tr class="my-th">
      <th>Column</th>
      <th>Valid Condition</th>
      <th>Block Alg</th>
      <th>Description</th>
    </tr>

    <xsl:apply-templates select="COL"/>

  </table>
  </div>  

</xsl:template>

<xsl:template match="COL">

  <tr class="my-td">
    <td><xsl:value-of select="IFD_FLD_ID"/></td>
    <td><xsl:value-of select="FLD_VAL"/></td>
    <td><PRE><xsl:value-of select="FLD_ALG"/></PRE></td>
    <td>
        <xsl:call-template name="SHOW_IFD_FLD_DESCR">
            <xsl:with-param name="p_descr" select="IFD_FLD_DESCR"/>
        </xsl:call-template>
    </td>
  </tr>

</xsl:template>

</xsl:stylesheet>


