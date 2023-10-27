<?xml version='1.0'?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="1.0">
<xsl:output method="html"/>

<xsl:include href="header.xsl"/>

<xsl:template match="/">
<html>
  <xsl:call-template name="GEN_SUBTITLE">
     <xsl:with-param name="p_subtitle" select="'Integration Transactions'"/>
  </xsl:call-template>

<body>
     <xsl:call-template name="GEN_HEADER">
       <xsl:with-param name="p_title" 
            select="'Integration Transactions - Table of Contents'"/>
     </xsl:call-template> 

<!-- HTML Output Basic Structure

Inbound

     File Based
     <IFD Table Row>
     <IFD Table Row>

     Trigger Based
     <IFD Table Row>
     <IFD Table Row>

Outbound

     <IFD Table Row>
     <IFD Table Row>

-->

<!-- Generate TOC -->
<xsl:call-template name="GEN_TOC"/>

<xsl:call-template name="GEN_POST_PROCESSING"/>

</body></html>
</xsl:template>

<xsl:template name="GEN_TOC">
  <h2>
     Inbound
  </h2>

  <div class="indent1">
  <table class="my-table">
    <tr class="my-th">
      <th>System</th>
      <th>IFD</th>
      <th>Version</th>
      <th>Event</th>
      <th>Event Group</th>
    </tr>
    <h2>
    Inbound IFD Based
    </h2> 
    <xsl:apply-templates select="//I_IFD_INDEXES/INDEX">
    </xsl:apply-templates>
  </table>
  </div>

  <div class="indent1">
  <table class="my-table">
    <tr class="my-th">
      <th>System</th>
      <th>IFD</th>
      <th>Version</th>
      <th>Event</th>
      <th>Event Group</th>
    </tr>
    <h2>
    Trigger Based
    </h2> 
    <xsl:apply-templates select="//I_TRG_INDEXES/INDEX">
    </xsl:apply-templates>
  </table>
  </div>

  <h2>
  Outbound 
  </h2> 
  <div class="indent1">
  <table class="my-table">
    <tr class="my-th">
      <th>System</th>
      <th>Result IFD</th>
      <th>IFD Version</th>
      <th>Event</th>
      <th>Event Group</th>
    </tr>
    <xsl:apply-templates select="//O_SYS_INDEXES/INDEX"/>
  </table>
  </div>

  <xsl:if test="//STK_STS_INDEX">
    <h2>
      Other
    </h2>
    <div class="indent1">
     <p>
      <a class="link" href="stk_status.html">Stock Status Map</a>
     </p>
    </div>
  </xsl:if>

</xsl:template>

<xsl:template match="O_SYS_INDEXES/INDEX">

      <tr class="my-td">
         <xsl:variable name="tran_link" select="TRANSACTION_DOC_NAME" />
         <xsl:variable name="page_link" select="RIFD_PAGE_DOC_NAME" />

         <td><xsl:value-of select="TRG_SYS"/></td>
         <td><a class="link" href="{$page_link}.html">
             <xsl:value-of select="IFD_ID"/></a></td>
         <td><a class="link" href="{$page_link}.html">
             <xsl:value-of select="IFD_VER"/></a></td>
         <td><a class="link" href="{$tran_link}.html">
             <xsl:value-of select="EVT_ID"/></a></td>
         <td><xsl:value-of select="EVT_GRP_ID"/></td>

      </tr>

</xsl:template>

<xsl:template match="//I_IFD_INDEXES/INDEX">
   <xsl:param name="p_evt_based" select="EVT_ID"/>

      <tr class="my-td">
         <xsl:variable name="tran_link" select="TRANSACTION_DOC_NAME" />
         <xsl:variable name="page_link" select="IIFD_PAGE_DOC_NAME" />

         <td><xsl:value-of select="TRG_SYS"/></td>
         <td><a class="link" href="{$page_link}.html">
             <xsl:value-of select="IFD_ID"/></a></td>
         <td><a class="link" href="{$page_link}.html">
             <xsl:value-of select="IFD_VER"/></a></td>
<xsl:choose>
<xsl:when test="$p_evt_based">
         <td><a class="link" href="{$tran_link}.html">
             <xsl:value-of select="EVT_ID"/></a></td>
         <td><xsl:value-of select="EVT_GRP_ID"/></td>
</xsl:when>
<xsl:otherwise>
         <td>Algorithm Based</td><td>N/A</td>
</xsl:otherwise>
</xsl:choose>
      </tr>

</xsl:template>

<xsl:template match="//I_TRG_INDEXES/INDEX">

      <tr class="my-td">
         <xsl:variable name="tran_link" select="TRANSACTION_DOC_NAME" />

         <td><xsl:value-of select="TRG_SYS"/></td>
         <td><a class="link" href="{$tran_link}.html">
             <xsl:value-of select="IFD_ID"/></a></td>
         <td><a class="link" href="{$tran_link}.html">
             <xsl:value-of select="IFD_VER"/></a></td>
         <td><a class="link" href="{$tran_link}.html">
             <xsl:value-of select="EVT_ID"/></a></td>
         <td><xsl:value-of select="EVT_GRP_ID"/></td>
      </tr>

</xsl:template>

</xsl:stylesheet>

