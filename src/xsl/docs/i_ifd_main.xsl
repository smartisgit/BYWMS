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
 <xsl:variable name="this_title" 
      select="concat('IFD Mapping: ',//IFD_DEF/IFD_ID,'|',//IFD_DEF/IFD_VER)"/>

 <xsl:call-template name="GEN_HEADER">
       <xsl:with-param name="p_title" select="$this_title" />
 </xsl:call-template>

<!-- HTML Output Basic Structure
     * IFD Definition (top lvl)
    * IIFD iifd (2nd lvl)
      * Segment Structure <linked> (3rd, 4th, etc lvl) 
        * Event(s)
      * Event e1 <linked> (2nd lvl)
        * RIFD rifd1 (3rd lvl)
              * Segment Structure <linked> (4th, 5th, etc lvl)
              * System(s)
                * System s1 (4th lvl)
        * RIFD rifd2
              * Segment Structure <linked>
              * System(s)
                * System s1
                * System s2
      * Event e2 <linked>
            .
            .
            .
   
     Event Identification
     <evt a; table cols>
     <evt b; table cols>

     IIFD Segment: <segment>
     <table of field data>

     RIFD Segment: <segment>  
     <table of field non-overstacked>
     <table of field overstacked>

-->

  <xsl:call-template name="GEN_NAV_TREE"/>

<!--
  Generate Event Identification Information
-->

  <xsl:call-template name="GEN_EVENT_DATA"/>

  <xsl:call-template name="GEN_MAPPINGS_DATA"/>

  <xsl:call-template name="GEN_POST_PROCESSING"/>

</body></html>
</xsl:template>

<xsl:template name="GEN_EVENT_DATA">
  <h2>
     Event Identification 
  </h2>
  <xsl:for-each select="//IFD_DEF/Event">
    <xsl:variable name="this_evt_id" select="EVT_ID" />
    <div class="section">
      <a name="{$this_evt_id}">
        Event: <xsl:value-of select="$this_evt_id"/>
      </a>
    </div>

    <div class="indent1">
    <table class="my-table">
      <tr class="my-th">
        <th>System</th>
        <th>Action</th>
        <th>Segment ID</th>
        <th>Field ID</th>
        <th>Value</th>
      </tr>

    <xsl:for-each select="SYSTEMS/SYSTEM">
      <xsl:variable name="this_sys_id" select="SYS_ID" />
      <xsl:for-each select="IDENTIFICATION">
        <span class="section">
          <tr class="my-td">
            <td><xsl:value-of select="$this_sys_id"/></td>
            <td><xsl:value-of select="IFD_ACTION"/></td>
            <td><xsl:value-of select="FLD_IFD_SEG_ID"/></td>
            <td><xsl:value-of select="FLD_IFD_FLD_ID"/></td>
            <td><xsl:value-of select="FLD_VAL"/></td>
          </tr>
        </span>
      </xsl:for-each> 
    </xsl:for-each> 
    </table> 
    </div>

  </xsl:for-each> 

</xsl:template>

</xsl:stylesheet>


