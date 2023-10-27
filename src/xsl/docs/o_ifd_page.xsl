<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="1.0">

<xsl:include href="header.xsl"/>

<xsl:output method="html"/>

     <!-- HTML Output Basic Structure
     IFD: <IFD_ID>|<IFD_VER>
     Description: <IFD_DESCR>
     Group: <IFD_GRP_TAG>
     From System: <SRC_SYS_ID>
     To Systems:  <OUT_SYS_ID>
                  <OUT_SYS_ID>
                  <OUT_SYS_ID>
     
     Segment:  <IFD_SEG_ID>

     ... Field Columns ...
     <Field Row Data..........> 
     <Field Row Data..........> 
     <Field Row Data..........> 
   -->

<xsl:template match="/">
<html>
   <xsl:call-template name="GEN_SUBTITLE">
     <xsl:with-param name="p_subtitle" select="'Integration documentation'"/>
  </xsl:call-template>

   <body>
     <xsl:choose>
         <xsl:when test="//RIFD/SYS_ID">
             <xsl:call-template name="GEN_HEADER">
                 <xsl:with-param name="p_title" select="concat('Result IFD Defn: ',//RIFD/IFD_ID,'|',//RIFD/IFD_VER,' From System: ',//RIFD/SYS_ID)"/>
             </xsl:call-template> 
         </xsl:when>
         <xsl:otherwise>
             <xsl:call-template name="GEN_HEADER">
                 <xsl:with-param name="p_title" select="concat('Result IFD Defn: ',//RIFD/IFD_ID,'|',//RIFD/IFD_VER,' From Inb IFD: ',//RIFD/IIFD_ID,'|',//RIFD/IIFD_VER)"/>
             </xsl:call-template> 
         </xsl:otherwise>
     </xsl:choose>

     <div class="section">
       <xsl:call-template name="SHOW_IFD_DESCR">
            <xsl:with-param name="p_descr" 
                 select="//RIFD/IFD_DESCR/IFD_DESCR"/>
              <xsl:with-param name="p_group" 
                 select="//RIFD/IFD_GRP_ID"/>
            <xsl:with-param name="p_ifd_id"
                 select="//RIFD/IFD_ID"/>
            <xsl:with-param name="p_ifd_ver"
                 select="//RIFD/IFD_VER"/>
            <xsl:with-param name="p_ifd_schema"
                 select="//RIFD/IFD_SCHEMA"/>
            <xsl:with-param name="p_ifd_schema_doc_name"
                 select="//RIFD/IFD_SCHEMA_DOC_NAME" />
       </xsl:call-template>
       <h2>
           <p>Destination Systems:</p>
       </h2>

       <div class="indent1">
          <table class="my-table">
              <tr class="my-th"> 
                  <th>Name</th> 
              </tr>

              <xsl:for-each select="//RIFD/RIFD_SYS">
                  <tr class="my-td">
                      <td><xsl:value-of select="DEST_SYS_ID"/></td>
                  </tr>
              </xsl:for-each>

          </table>
       </div>
     </div>

     <xsl:apply-templates select="//RIFD_SEG"/>

     <xsl:call-template name="GEN_POST_PROCESSING"/>

   </body>
</html>
</xsl:template>

<xsl:template match="RIFD_SEG"> 
     <div class="section">

       <xsl:variable name="this_seg_id" select="IFD_SEG_ID" />

       <a name="{$this_seg_id}">
       <h2>IFD Segment: <xsl:value-of select="$this_seg_id"/></h2>

       <xsl:call-template name="SHOW_IFD_SEG_DESCR">
            <xsl:with-param name="p_descr" 
                 select="IFD_SEG_DESCR/IFD_SEG_DESCR"/>
       </xsl:call-template>

       </a>

       <xsl:call-template name="GEN_FLD_TABLE">
            <xsl:with-param name="p_ifd_seg_id" select="$this_seg_id"/>
       </xsl:call-template>

       <br/> 
     </div>
</xsl:template>

<xsl:template name="GEN_FLD_TABLE">
<xsl:param name="p_ifd_seg_id"/>

  <h3>
  Fields 
  </h3>
  <div class="indent1">
  <table class="my-table">
    <tr class="my-th">
        <th>Field ID</th>
        <th>Description</th>
        <th>Pos</th>
        <th>Length</th>
        <th>Max Chars</th>
        <th>Format</th>
        <th>Mapping</th>
        <th>OS Flg</th>
        <th>Create Expr</th>
        <th>Change Expr</th>
        <th>Validation Cmnt</th> 
        <th>Default Value Cmnt</th> 
        <th>Required</th> 
    </tr>

    <xsl:apply-templates select="//RIFD_MAP[IFD_SEG_ID=$p_ifd_seg_id]"/>

  </table>
  </div>
</xsl:template>

<xsl:template match="RIFD_MAP">
  <xsl:variable name="this_data_lay_cd" 
       select="ancestor::RIFD/DATA_LAY_CD" />

  <tr class="my-td">
    <td><xsl:value-of select="IFD_FLD_ID"/></td>
    <td>
        <xsl:call-template name="SHOW_IFD_FLD_DESCR">
            <xsl:with-param name="p_descr" select="IFD_FLD_DESCR"/>
        </xsl:call-template>
    </td>
    <td>
        <xsl:choose>
            <xsl:when test="$this_data_lay_cd='F'">
                <xsl:value-of select="IFD_FLD_POS"/>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
         </xsl:choose>
    </td>
    <td><xsl:value-of select="IFD_FLD_LEN"/></td>
    <td><xsl:value-of select="IFD_FLD_MAX_CHARS"/></td>
    <td><xsl:value-of select="FLD_FMT"/></td>
    <td><xsl:value-of select="REMAPPED_EXPR"/></td>
    <td><xsl:value-of select="OVERSTACK_FLG"/></td>
    <td><xsl:value-of select="CREATE_EXPR"/></td>
    <td><xsl:value-of select="CHANGE_EXPR"/></td>
    <td>
        <xsl:call-template name="SHOW_VALIDATION_CMNT">
            <xsl:with-param name="p_descr" select="VALIDATION_CMNT"/>
        </xsl:call-template>
    </td> 
    <td>
        <xsl:call-template name="SHOW_DEFAULT_VAL_CMNT">
            <xsl:with-param name="p_descr" select="DEFAULT_VAL_CMNT"/>
        </xsl:call-template>
    </td> 
    <td><xsl:value-of select="REQUIRED_FLG"/></td> 
  </tr>
</xsl:template>


</xsl:stylesheet>

