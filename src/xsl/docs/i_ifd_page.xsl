<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:include href="header.xsl"/>
    <xsl:output method="html"/>
    <!-- HTML Output Basic Structure
     IFD: <IFD_ID>|<IFD_VER>
     Description: <IFD_DESCR>
     Group: <IFD_GRP_TAG>
     
     IFD Segment Identifying Algorithms 
     <System; Algorithm; Description>

     Segment:  <IFD_SEG_ID>

     Indentification
     <System; Segment; Field; Value>     
     
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
                <xsl:call-template name="GEN_HEADER">
                    <xsl:with-param name="p_title" select="concat('IFD Defn: ',//IFD_DEF/IFD_ID,'|',//IFD_DEF/IFD_VER)"/>
                </xsl:call-template>
                <div class="section" style="width: 883; height: 1098">
                    <xsl:call-template name="SHOW_IFD_DESCR">
                         <xsl:with-param name="p_descr" 
                              select="//IFD_DEF/IFD_DESCR/IFD_DESCR"/>
                         <xsl:with-param name="p_group" 
                              select="//IFD_DEF/IFD_GRP_TAG"/>
                         <xsl:with-param name="p_ifd_id" 
                              select="//IFD_DEF/IFD_ID"/>
                         <xsl:with-param name="p_ifd_ver" 
                              select="//IFD_DEF/IFD_VER"/>
                         <xsl:with-param name="p_ifd_schema"
                              select="//IFD_DEF/IFD_SCHEMA"/>
                         <xsl:with-param name="p_ifd_schema_doc_name"
                              select="//IFD_DEF/IFD_SCHEMA_DOC_NAME" />
                    </xsl:call-template>
<xsl:if test="//IFD_DEF/IDENT_ALGS">
        <h3>
  IFD Segment Identifying Algorithms 
  </h3>
        <div class="indent1" >
            <table class="my-table">
                <tr class="my-th">
                    <th>System</th>
                    <th>Algorithm</th>
                    <th>Description</th>
                </tr>
                <xsl:apply-templates select="//IFD_DEF/IDENT_ALGS">
    </xsl:apply-templates>
            </table>
        </div>
</xsl:if>

                    <xsl:apply-templates select="//SEG"/>
                    <xsl:call-template name="GEN_POST_PROCESSING"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="IDENT_ALGS">
        <tr class="my-td">
            <td>
                <xsl:value-of select="SYS_ID"/>
            </td>
            <td>
                <xsl:value-of select="ID_SEG_ALG_ID"/>
            </td>
            <td>
                <xsl:value-of select="ID_SEG_ALG_DESCR"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="SEG">
        <div class="section">
            <xsl:variable name="this_seg_id" select="IFD_SEG_ID"/>
            <a name="{$this_seg_id}">
                <h2>IFD Segment: <xsl:value-of select="$this_seg_id"/>
                </h2>
            </a>
            <xsl:call-template name="SHOW_IFD_SEG_DESCR">
                <xsl:with-param name="p_descr" select="IFD_SEG_DESCR/IFD_SEG_DESCR"/>
            </xsl:call-template>
            <xsl:call-template name="GEN_IDENT_TABLE"/>
            <xsl:call-template name="GEN_FLD_TABLE"/>
            <br/>
        </div>
    </xsl:template>
    <xsl:template name="GEN_IDENT_TABLE">
        <h3>
  Identifiers
  </h3>
        <div class="indent1" >
            <table class="my-table">
                <tr class="my-th">
                    <th>System</th>
                    <th>IFD Field</th>
                    <th>Value</th>
                </tr>
                <xsl:apply-templates select="SEG_IDENT">
    </xsl:apply-templates>
            </table>
        </div>
    </xsl:template>
    <xsl:template match="SEG_IDENT">
        <tr class="my-td">
            <td>
                <xsl:value-of select="SYS_ID"/>
            </td>
            <td>
                <xsl:value-of select="IFD_FLD_ID"/>
            </td>
            <td>
                <xsl:value-of select="FLD_VAL"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template name="GEN_FLD_TABLE">
        <h3>
  Fields 
  </h3>
        <div class="indent1">
            <table class="my-table">
                <tr class="my-th">
                    <th>Field ID</th>
                    <th>Tag</th>
                    <th>Description</th>
                    <th>Pos</th>
                    <th>Type</th>
                    <th>Max Chars</th>
                    <th>Alg</th>
                    <th>Format</th>
                    <th>Justify</th>
                    <th>Trim</th>
                    <th>Tr Ch</th>
                    <th>Attr Cd</th>
                    <th>Validation Cmnt</th>
                    <th>Default Value Cmnt</th>
                    <th>Required</th>
                </tr>
                <xsl:apply-templates select="FLD">
    </xsl:apply-templates>
            </table>
        </div>
    </xsl:template>
    <xsl:template match="FLD">
        <xsl:variable name="this_data_lay_cd" select="ancestor::IFD_DEF/DATA_LAY_CD"/>
        <tr class="my-td">
            <td>
                <xsl:value-of select="IFD_FLD_ID"/>
            </td>
            <td>
                <xsl:value-of select="IFD_FLD_TAG"/>
            </td>
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
            <td>
                <xsl:value-of select="DATA_TYP_CD"/>
                <xsl:value-of select="IFD_FLD_LEN"/>
            </td>
            <td>
                <xsl:value-of select="IFD_FLD_MAX_CHARS"/>
            </td>
            <td>
                <xsl:value-of select="FLD_ALG_ID"/>
            </td>
            <td>
                <xsl:value-of select="FLD_FMT"/>
            </td>
            <td>
                <xsl:value-of select="FLD_JUS_CD"/>
            </td>
            <td>
                <xsl:value-of select="FLD_TRM_CD"/>
            </td>
            <td>
                <xsl:value-of select="TRM_CHAR"/>
            </td>
            <td>
                <xsl:value-of select="IFD_FLD_ATTR_CD"/>
            </td>
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
            <td>
                <xsl:value-of select="REQUIRED_FLG"/>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
