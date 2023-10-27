<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:variable name="relative_path">
       <xsl:choose>
          <xsl:when test="//LOCALE_ID='US_ENGLISH'">../</xsl:when>
          <xsl:otherwise>../../</xsl:otherwise>
       </xsl:choose>
    </xsl:variable>
    <xsl:template name="GEN_HEADER">
        <xsl:param name="p_title"/>
        <table class="title-table">
            <tr valign="bottom">
                <td>
                    <span class="title">
                        <xsl:value-of select="$p_title"/>
                    </span>
                    <xsl:choose>
                        <xsl:when test="//INDEX"/>
                        <xsl:otherwise>
                            <span class="backlink">
                                <a class="link" href="index.html">
            [INTEGRATION INDEX]
            </a>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
                <td>
                    <a href="../index.html">
                    <img align="right" border="0" alt="E2e Documentation" src="{$relative_path}gif/redprairie.gif"/>
                    </a>
                </td>
            </tr>
        </table>
        <hr size="1"/>
    </xsl:template>
    
    <xsl:template name="GEN_SUBTITLE">
        <xsl:param name="p_subtitle"/>
        <head>

            <link rel="stylesheet" type="text/css" href="{$relative_path}css/redprairie.css"/>
            <STYLE type="text/css">
          .tree {font-weight: bold;
                  text-decoration:none
                  font-style: normal;
                  height: 16pt;
                 }

          a.tree {color:#0000aa; 
                  text-decoration:none;
                  font-weight: normal;
                  font-style: normal;
                  height: 16pt;
                 }
          a.tree:visited {color:#0000aa; text-decoration:none}
          a.tree:hover   {color:#cc0000;  text-decoration:none}

.collapsible {
  background-color: white;
  color: #0000aa;
  cursor: pointer;
  width: 100%;
  border: none;
  text-align: left;
  outline: none;
}

.active, .collapsible:hover {
  background-color: #ffebeb
}

.collapsible:after {
  content: '\002B';
  color: white;
  font-weight: bold;
  float: right;
  margin-left: 5px;
}

.active:after {
  content: "\2212";
}

.content {
  padding: 0 18px;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.2s ease-out;
  background-color: #f1f1f1;
}


    </STYLE>

        </head>
        <title>
            <xsl:value-of select="$p_subtitle"/>
        </title>
        <meta charset="UTF-8"/>
    </xsl:template>
    <xsl:template name="GEN_SEG_ALG_TABLE">
        <h2>
  Algorithms
  </h2>
        <div class="indent1">
            <table class="my-table">
                <tr class="my-th">
                    <th>Type</th>
                    <th>Alg</th>
                </tr>
                <tr class="my-td">
                    <td>Pre-Alg</td>
                    <td>
                        <xsl:value-of select="SEG_ALGS/PRE_ALG_ID"/>
                    </td>
                </tr>
                <tr class="my-td">
                    <td>Post Alg</td>
                    <td>
                        <xsl:value-of select="SEG_ALGS/POST_ALG_ID"/>
                    </td>
                </tr>
                <tr class="my-td">
                    <td>Pre-Alg</td>
                    <td>
                        <xsl:value-of select="SEG_ALGS/BLK_ALG_ID"/>
                    </td>
                </tr>
                <tr class="my-td">
                    <td>Pre-Alg</td>
                    <td>
                        <xsl:value-of select="SEG_ALGS/PROC_ALG_ID"/>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template>
    <xsl:template name="GEN_NAV_TREE">
<!-- ===================== -->
<!-- Top Level - Inbound IFD Name -->
<!-- ===================== -->
<img align="left" border="0" src="{$relative_path}gif/sl_top.gif"/>
<span class="tree">Navigation Tree</span>
<xsl:if test="//IFD_DEF">
    <!-- ===================== -->
    <!-- Second Level - IIFD Name -->
    <!-- ===================== -->
    <ul>
        <li>
            <table border="0">
                <tr>
                    <td>
                        <img align="left" border="0" src="{$relative_path}gif/sl_in_ifd.gif"/>
                        <xsl:choose>
                            <xsl:when test="//XML_DOC_PAGE_NAME">
                                <xsl:variable name="this_doc_page" select="concat(//XML_DOC_PAGE_NAME,'.html')"/>
                                <a class="tree" href="{$this_doc_page}">
                                    <xsl:value-of select="concat(//IFD_DEF/IFD_ID,' ',//IFD_DEF/IFD_VER)"/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(//IFD_DEF/IFD_ID,' ',//IFD_DEF/IFD_VER)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </td>
                    <td class="packagelink">
                        <xsl:variable name="this_i_ifd_and_ver" select="translate(concat(//IFD_DEF/IFD_ID,'__',//IFD_DEF/IFD_VER),' \/|','_!!!')"/>
                        <a href="../../uc_rev_log/sl_i_ifd/{$this_i_ifd_and_ver}.html" target="_blank">Change Log</a>
                    </td>
                </tr>
            </table>
        </li>
                <!-- Third Level, Fourth, Fifth - IFD SEGMENT Structure-->
                <xsl:for-each select="//IFD_SEGS/IFD_SEG">
                    <xsl:choose>
                        <!-- Current Seg Level is greater than previous or positon() = 1 -->
                        <xsl:when test="(position() = 1) or 
                           (IFD_SEG_LEVEL > preceding::IFD_SEG_LEVEL[1])">
                            <xsl:text><![CDATA[<ul>]]></xsl:text>
                            <xsl:call-template name="GEN_LINK">
                                <xsl:with-param name="p_name" select="./IFD_SEG_ID"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="IFD_SEG_LEVEL = preceding::IFD_SEG_LEVEL[1]">
                            <!-- Current Seg Level is equal to previous -->
                            <xsl:call-template name="GEN_LINK">
                                <xsl:with-param name="p_name" select="./IFD_SEG_ID"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--  The Current Seg Level is less than the previous level -->
                            <xsl:call-template name="GEN_IFD_LISTCLOSE">
                                <xsl:with-param name="p_numclose" select="preceding::IFD_SEG_LEVEL[1]-IFD_SEG_LEVEL"/>
                            </xsl:call-template>
                            <xsl:call-template name="GEN_LINK">
                                <xsl:with-param name="p_name" select="./IFD_SEG_ID"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- if last position, we need to see what level we are at and append the appropriate number /ul  -->
                    <xsl:if test="position() = last()">
                        <xsl:call-template name="GEN_IFD_LISTCLOSE">
                            <xsl:with-param name="p_numclose" select="IFD_SEG_LEVEL+1"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </ul>
        </xsl:if>
<!-- ===================== -->
<!-- Second Level - Events -->
<!-- ===================== -->
<ul>
    <li>
        <img align="left" border="0" src="{$relative_path}gif/sl_open_folder.gif"/>
        <span class="tree">Event(s)</span>
    </li>

    <!-- ==== SHOW EACH EVENT -->
    <ul>
        <xsl:for-each select="//Event">
            <xsl:variable name="this_evt_id" select="EVT_ID"/>
            <xsl:variable name="this_evt_id_lnk" select="translate(EVT_ID,' \/|','_!!!')"/>
            <li>
                <table border="0">
                    <tr>
                        <td>
                            <img align="left" border="0" src="{$relative_path}gif/sl_event.gif"/>
                            <xsl:choose>
                                <xsl:when test="//IFD_DEF">
                                    <a class="tree" href="#{$this_evt_id}">
                                        <xsl:value-of select="$this_evt_id"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$this_evt_id"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </td>
                        <td class="packagelink"><a href="../../uc_rev_log/sl_evt/{$this_evt_id_lnk}.html" target="_blank">Event Change Log</a></td>
                        <td class="packagelink"><a href="../../uc_rev_log/sl_alt_evt_arg/{$this_evt_id_lnk}.html" target="_blank">Alternate Event Argument Change Log</a></td>
                    </tr>
                </table>
            </li>
            <!-- Above is end li of the event -->


            <!-- =======EVENT ARGUMENTS====== -->
            <ul>
                <li>
                    <button type="button" class="collapsible"><i>Event Arguments</i></button>
                    <div class="content">
                        <table class="my-table">
                            <tr class="my-th"  style="font-size:75%">
                                <th>Argument ID</th>
                                <th>Description</th>
                                <th>Type</th>
                                <th>Required?</th>
                                <th>Alternate Expression</th>
                            </tr>
                            <xsl:for-each select="SYSTEM/uc_evt_args/uc_evt_arg">
                                <tr class="my-td"  style="font-size:75%">
                                    <td><xsl:value-of select="EVT_ARG_ID"/></td>
                                    <td><xsl:value-of select="EVT_ARG_DESCR"/></td>
                                    <td><xsl:value-of select="DATA_TYP_CD"/></td>
                                    <td><xsl:value-of select="REQUIRE_FLG"/></td>
                                    <td><xsl:value-of select="ALT_EVT_ARG_ID"/></td>
                                </tr>
                            </xsl:for-each>
                            <!-- each evebt arg -->
                        </table>
                    </div>
                    <!-- end of conttnt div -->
                </li>
            </ul>
            <!-- End of Event arg area -->

            <!-- =======EVENT OUTPUTS====== -->
            <ul>
                <xsl:for-each select="//Event[EVT_ID=$this_evt_id]/SYSTEM/uc_eos/uc_eo">
                    <xsl:variable name="this_eo_id" select="EO_ID"/>
                    <xsl:variable name="this_eo_ver" select="EO_VER"/>
                    <xsl:variable name="this_eo_and_ver" select="translate(concat(EO_ID, '__', EO_VER),' /|\', '_!!!')"/>
                    <li>
                        <table border="0">
                            <tr>
                                <td>
                                    <img align="left" border="0" src="{$relative_path}gif/sl_eo.gif"/>
                                    <a class="tree"> <xsl:value-of select="concat(EO_ID,'/', EO_VER)"/></a>
                                </td>
                                <td class="packagelink">
                                    <a href="../../uc_rev_log/sl_eo/{$this_eo_and_ver}.html" target="_blank">Change Log</a>
                                </td>
                            </tr>
                        </table>
                    </li>

                    <!-- ======= EO Segments ====== -->
                    <xsl:for-each select="uc_eo_segs/uc_eo_seg">
                        <xsl:value-of select="UC_INDENT_UL"/>
                            <li>
                                <button type="button" class="collapsible">
                                    <img align="left" border="0" src="{$relative_path}gif/sl_eo_seg.gif"/>
                                    <xsl:value-of select="concat(EO_SEG_ID,' ', EO_SEG_DESCR)"/>
                                </button>
                                <div class="content">
                                    <table class="my-table">
                                        <tr class="my-th">
                                            <th>Retrieve Method</th>
                                            <th>Retrieve Method Algorithm</th>
                                            <th>Blocking Algorithm</th>
                                            <th>Blocking Algorithm Evaluation</th>
                                        </tr>
                                        <tr class="my-td">
                                            <td><xsl:value-of select="RETR_MTHD_ID"/></td>
                                            <td><xsl:value-of select="UC_RETR_MTHD_ALG_ID"/></td>
                                            <td><xsl:value-of select="BLK_ALG_ID"/></td>
                                            <td><xsl:value-of select="BLK_ALG_EVAL_CD"/></td>
                                        </tr>
                                    </table>

                                    <!-- ======== EO Feilds =============== -->
                                    <table class="my-table">
                                        <tr class="my-th">
                                            <th>EO Field</th>
                                            <th>Description</th>
                                            <th>Length</th>
                                            <th>Type</th>
                                            <th>Seq#</th>
                                            <th>Mapped Column</th>
                                            <th>Grouped?</th>
                                            <th>SQL Order#</th>
                                        </tr>
                                        <xsl:for-each select="uc_eo_flds/uc_eo_fld">
                                            <tr class="my-td">
                                                <td><xsl:value-of select="EO_FLD_ID"/></td>
                                                <td><xsl:value-of select="EO_FLD_DESCR"/></td>
                                                <td><xsl:value-of select="EO_FLD_LEN"/></td>
                                                <td><xsl:value-of select="DATA_TYP_CD"/></td>
                                                <td><xsl:value-of select="SQL_COMPONENT_SEQ"/></td>
                                                <td><xsl:value-of select="SQL_CRSR_COL"/></td>
                                                <td><xsl:value-of select="GRP_BY_FLG"/></td>
                                                <td><xsl:value-of select="EO_FLD_SQL_ORDR"/></td>
                                            </tr>
                                        </xsl:for-each>
                                        <!-- end of fetch loop of eo fields -->
                                    </table>
                                    <!-- end of table that has EO filds -->
                                </div>
                                <!-- end of div with collapsable eo seg contents -->
                             </li>
                             <!-- end of list tag for EO Seg -->
                        <xsl:value-of select="UC_OUTDENT_UL"/>
                        <!-- end of a seg so outdent -->
                    </xsl:for-each>
                    <!-- all eos sehgments -->

                    <!-- ======= RESULT IFDS FOR EO ===== -->
                    <xsl:for-each select="RIFDS/RIFD">
                        <xsl:variable name="this_rifd_id" select="IFD_ID"/>
                        <xsl:variable name="this_rifd_ver" select="IFD_VER"/>
                        <xsl:variable name="this_ifd_and_ver" select="translate(concat(IFD_ID, '__', IFD_VER),' /|\', '_!!!')"/>
                        <xsl:variable name="this_rifd_link">
                            <xsl:choose>
                                <xsl:when test="RIFD_PAGE_DOC_NAME">
                                    <xsl:value-of select="concat(RIFD_PAGE_DOC_NAME,'.html')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('#',IFD_ID,IFD_VER)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="this_rifd_seg_link">
                            <xsl:choose>
                                <xsl:when test="RIFD_PAGE_DOC_NAME">
                                    <xsl:value-of select="concat(RIFD_PAGE_DOC_NAME,'.html','#')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('#',IFD_ID,IFD_VER)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <ul>
                            <li>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <img align="left" border="0" src="{$relative_path}gif/sl_out_ifd.gif"/>
                                            <a class="tree" href="{$this_rifd_link}">
                                                <xsl:value-of select="$this_rifd_id"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="$this_rifd_ver"/>
                                            </a>
                                        </td>
                                        <td class="packagelink">
                                            <a href="../../uc_rev_log/sl_o_ifd/{$this_ifd_and_ver}.html" target="_blank">IFD Change Log</a>
                                        </td>
                                        <td class="packagelink">
                                            <a href="../../uc_rev_log/sl_o_ifd_sys_map/{$this_ifd_and_ver}.html" target="_blank">IFD Mapping Change Log</a>
                                        </td>
                                    </tr>
                                </table>
                            </li>

                            <!-- ======= RESULT IFD SEGMETS FOR THE IFD ===== -->
                            <!-- Fourth, Fifth, ... Level - Get the RIFD Segments for the selected rifd_id, rifd_ver -->
                            <xsl:for-each select="RIFD_SEGS/RIFD_SEG">
                                <xsl:choose>
                                    <!-- Current Seg Level is greater than previous see we are adding a ul tag-->
                                    <xsl:when test="(position() = 1) or (IFD_SEG_LEVEL > preceding::IFD_SEG_LEVEL[1])">
                                        <xsl:text><![CDATA[<ul>]]></xsl:text>
                                        <li>
                                            <img align="left" border="0" src="{$relative_path}gif/sl_out_ifd_seg.gif"/>
                                            <a class="tree" href="{$this_rifd_seg_link}{IFD_SEG_ID}">
                                                <xsl:value-of select="IFD_SEG_ID"/>
                                            </a>
                                        </li>
                                    </xsl:when>
                                    <xsl:when test="EO_SEG_LEVEL = preceding::IFD_SEG_LEVEL[1]">
                                        <!-- Current Seg Level is equal to previous Compare to above no ul added here-->
                                        <li>
                                            <img align="left" border="0" src="{$relative_path}gif/sl_out_ifd_seg.gif"/>
                                            <a class="tree" href="{$this_rifd_seg_link}{IFD_SEG_ID}">
                                                <xsl:value-of select="IFD_SEG_ID"/>
                                            </a>
                                        </li>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!--  The Current Seg Level is less than the previous level -->
                                        <xsl:call-template name="GEN_RIFD_LISTCLOSE">
                                            <xsl:with-param name="p_rifd_id" select="$this_rifd_id"/>
                                            <xsl:with-param name="p_rifd_ver" select="$this_rifd_ver"/>
                                            <xsl:with-param name="p_evt_id" select="$this_evt_id"/>
                                            <xsl:with-param name="p_eo_id" select="$this_eo_id"/>
                                            <xsl:with-param name="p_eo_ver" select="$this_eo_ver"/>
                                            <xsl:with-param name="p_numclose" select="preceding::IFD_SEG_LEVEL[1]-IFD_SEG_LEVEL"/>
                                        </xsl:call-template>
                                        <li>
                                            <img align="left" border="0" src="{$relative_path}gif/sl_out_ifd_seg.gif"/>
                                            <a class="tree" href="{$this_rifd_seg_link}{IFD_SEG_ID}">
                                                <xsl:value-of select="IFD_SEG_ID"/>
                                            </a>
                                        </li>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <!-- if last position, we need to see what level we are at and append the appropriate number \li \ul  -->
                                <xsl:if test="position() = last()">
                                    <xsl:call-template name="GEN_RIFD_LISTCLOSE">
                                        <xsl:with-param name="p_rifd_id" select="$this_rifd_id"/>
                                        <xsl:with-param name="p_rifd_ver" select="$this_rifd_ver"/>
                                        <xsl:with-param name="p_evt_id" select="$this_evt_id"/>
                                        <xsl:with-param name="p_numclose" select="IFD_SEG_LEVEL+1"/>
                                        <xsl:with-param name="p_eo_id" select="$this_eo_id"/>
                                        <xsl:with-param name="p_eo_ver" select="$this_eo_ver"/>
                                        <!-- The +1 caps off the open list -->
                                    </xsl:call-template>
  
                                    <!-- ======= SYSTEMS FOR THE RESULT IFD ===== -->
                                    <!-- Put out systems for RIFD at same level -->
                                    <ul>
                                        <li>
                                            <img align="left" border="0" src="{$relative_path}gif/sl_open_folder.gif"/>
                                            <span class="tree">Systems</span>
                                        </li>

                                        <!-- ======= PUT EACH SYSTEM ===== -->
                                        <ul>
                                            <xsl:for-each select="../../RIFD_SYSTEMS/RIFD_SYS">
                                                <xsl:variable name="this_dest_sys_id" select="translate(DEST_SYS_ID,' /|\', '_!!!')"/>
                                                <xsl:variable name="this_comm_mthd_cl" select="translate(COMM_MTHD_ID,' /|\', '_!!!')"/>
                                                <xsl:variable name="this_comm_mode_cd_cl" select="'ASYNC'"/>
                                                <li>
                                                    <button type="button" class="collapsible">
                                                        <table border="0">
                                                            <tr>
                                                                <td>
                                                                    <img align="left" border="0" src="{$relative_path}gif/sl_system.gif"/>
                                                                    <xsl:value-of select="DEST_SYS_ID"/>
                                                                </td>
                                                                <td class="packagelink">
                                                                    <a href="../../uc_rev_log/sl_sys/{$this_dest_sys_id}.html" target="_blank">Change Log</a>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </button>
                                                    <div class="content">
                                                        <table class="my-table">
                                                            <tr class="my-td" style="font-size:75%">
                                                                <td><b>Execute Algorithm</b></td>
                                                                <td><xsl:value-of select="BLK_ALG_ID"/>,<xsl:value-of select="BLK_ALG_EVAL_CD"/></td>
                                                            </tr>
                                                            <tr class="my-td" style="font-size:75%">
                                                                <td><b>Send As</b></td>
                                                                <td><xsl:value-of select="UC_COMM_MODE_CD_DESCR"/></td>
                                                            </tr>
                                                            <tr class="my-td" style="font-size:75%">
                                                                <td><b>Using Comm Method</b></td>
                                                                <td><xsl:value-of select="COMM_MTHD_ID"/></td>
                                                            </tr>
                                                            <tr class="my-td" style="font-size:75%">
                                                                <td><b>Before Sending Execute Algorithm:</b></td>
                                                                <td><xsl:value-of select="UC_CM_PRE_ALG_ID"/></td>
                                                            </tr>
                                                            <tr class="my-td" style="font-size:75%">
                                                                <td><b>Execute For Sending:</b></td>
                                                                <td><xsl:value-of select="UC_CM_ALG_ID"/></td>
                                                            </tr>
                                                            <tr class="my-td" style="font-size:75%">
                                                                <td><b>Afterwards Execute:</b></td>
                                                                <td><xsl:value-of select="UC_CM_POST_ALG_ID"/></td>
                                                            </tr>
                                                            <tr class="my-td" style="font-size:75%">
                                                                <td valign="top"><b>Change Log:</b></td>
                                                                <td class="packagelink" align="left" valign="top">
                                                                    <ul>
                                                                        <xsl:if test="$this_comm_mthd_cl">
                                                                            <li align="left"><a href="../../uc_rev_log/sl_comm_mthd/{$this_comm_mthd_cl}.html" target="_blank">Communication Method</a></li>
                                                                        </xsl:if>
                                                                        <li align="left"><a href="../../uc_rev_log/sl_sys_comm/{$this_dest_sys_id}.html" target="_blank">System Communication</a></li>
                                                                    </ul>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <!-- table with fixed rows for system data -->
                                                        <table class="my-table">
                                                            <tr class="my-th" style="font-size:70%">
                                                                <th>Attribute</th>
                                                                <th>Literal Value</th>
                                                                <th>Via Algorithm</th>
                                                                <th>Algorithm Arguments</th>
                                                                <th>Change Log Sys Comm Val</th>
                                                            </tr>
                                                            <xsl:for-each select="uc_rifd_sys_comm_vals/uc_rifd_sys_comm_val">
                                                                <tr class="my-td" style="font-size:70%">
                                                                    <td><xsl:value-of select="COMM_MTHD_ATTR"/></td>
                                                                    <td><xsl:value-of select="COMM_MTHD_ATTR_VAL"/></td>
                                                                    <td><xsl:value-of select="ALG_ID"/></td>
                                                                    <td style="font-size:50%"><xsl:value-of select="BND_DATA"/></td>
                                                                    <!-- CHANGE LOG comment uses ASYNCE for SYNCE -->
                                                                    <xsl:choose>
                                                                        <xsl:when test="this_comm_mode_cd='ASYNC'">
                                                                            <xsl:variable name="this_sys_comm_val_cl" select="translate(concat($this_dest_sys_id, '__SYNCE__O__', $this_comm_mthd_cl, '__', COMM_MTHD_ATTR), ' /|\', '_!!!')"/>
                                                                            <td class="packagelink" align="left">
                                                                                <a href="../../uc_rev_log/sl_sys_comm_val/{$this_sys_comm_val_cl}.html" target="_blank">Change Log</a>
                                                                            </td>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                            <xsl:variable name="this_sys_comm_val_cl" select="translate(concat($this_dest_sys_id, '__', $this_comm_mode_cd_cl, '__O__', $this_comm_mthd_cl, '__', COMM_MTHD_ATTR), ' /|\', '_!!!')"/>
                                                                            <td class="packagelink" align="left">
                                                                                <a href="../../uc_rev_log/sl_sys_comm_val/{$this_sys_comm_val_cl}.html" target="_blank">Change Log</a>
                                                                            </td>
                                                                        </xsl:otherwise>
                                                                    </xsl:choose>
                                                                </tr>
                                                            </xsl:for-each>
                                                        </table>
                                                        <!-- system args -->
                                                    </div>
                                                    <!-- end of collapsable system data -->
                                                </li>
                                                <!-- end of bullet for system -->
                                            </xsl:for-each>
                                            <!-- end of fetch looop -->
                                        </ul>
                                        <!-- end of ul for system-->
                                    </ul>
                                    <!-- Systems Node -->
                                </xsl:if>
                                <!-- we are at last IFD Segment -->
                            </xsl:for-each>
                            <!-- each rifd segment -->
                        </ul>
                        <!-- close list for ifd segments.  Indented for tree -->
                    </xsl:for-each>
                    <!-- each rifd -->
                </xsl:for-each>
                <!-- each EO -->
            </ul>
            <!-- close list for the EOs -->
        </xsl:for-each>
        <!-- each event -->
    </ul>
    <!-- close UL for events -->
</ul>
<BR/>
</xsl:template>
    <xsl:template name="GEN_IFD_LISTCLOSE">
        <xsl:param name="p_numclose"/>
        <!-- p_numends = number of list closes
       Use the IFD_SEGMENTS for the IFD to generate a loop that we can 
       test against to produce the proper number of list closes for these segments.
       NOTE: This is the only way, at the time, I could think of to generate the 
             appropriate amount of list close(s). 
  -->
        <xsl:for-each select="//IFD_SEGS/IFD_SEG">
            <xsl:if test="($p_numclose >= position())">
              <xsl:text><![CDATA[</ul>]]></xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="GEN_LINK">
        <xsl:param name="p_name"/>
        <xsl:variable name="this_xml_page_name">
            <xsl:choose>
                <xsl:when test="//XML_DOC_PAGE_NAME">
                    <xsl:value-of select="concat(//XML_DOC_PAGE_NAME,'.html#')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'#'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <li>
            <img align="left" border="0" src="{$relative_path}gif/sl_in_ifd_seg.gif"/>
            <a class="tree" href="{$this_xml_page_name}{$p_name}">
                <xsl:value-of select="$p_name"/>
            </a>
        </li>
    </xsl:template>
    <xsl:template name="GEN_RIFD_LISTCLOSE">
        <xsl:param name="p_rifd_id"/>
        <xsl:param name="p_rifd_ver"/>
        <xsl:param name="p_evt_id"/>
        <xsl:param name="p_eo_id"/>
        <xsl:param name="p_eo_ver"/>
        <xsl:param name="p_numclose"/>
        <xsl:for-each select="//Event[EVT_ID=$p_evt_id]/SYSTEM/uc_eos/uc_eo[EO_ID=$p_eo_id and EO_VER=$p_eo_ver]/RIFDS/RIFD[IFD_ID=$p_rifd_id and IFD_VER=$p_rifd_ver]/RIFD_SEGS/RIFD_SEG">
            <xsl:if test="($p_numclose >= position())">
                <xsl:text><![CDATA[</ul>]]></xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="GEN_MAPPINGS_DATA">
        <br/>
        <h2>
            Result IFD Mapping ...
         </h2>
        <xsl:for-each select="//Event/SYSTEM/uc_eos/uc_eo/RIFDS/RIFD">
            <xsl:variable name="this_evt_id" select="../../../../../EVT_ID"/>
            <xsl:variable name="this_ifd_id" select="IFD_ID"/>
            <xsl:variable name="this_ifd_ver" select="IFD_VER"/>
            <div class="section">
                <h2>Event: <xsl:value-of select="$this_evt_id"/>
                </h2>
                <xsl:if test="SYS_ID">
                    <h2>From System: <xsl:value-of select="SYS_ID"/>
                    </h2>
                </xsl:if>
                
                <a name="{$this_ifd_id}{$this_ifd_ver}">
                    <h2>IFD: <xsl:value-of select="concat($this_ifd_id,'|',$this_ifd_ver)"/>
                    </h2>
                </a>
                <xsl:call-template name="SHOW_IFD_DESCR">
                    <xsl:with-param name="p_descr" select="IFD_DESCR/IFD_DESCR"/>
                    <xsl:with-param name="p_group" select="IFD_GRP_TAG"/>
                                        <xsl:with-param name="p_ifd_id" select="IFD_ID"/>
                                        <xsl:with-param name="p_ifd_ver" select="IFD_VER"/>
                                        <xsl:with-param name="p_pre_alg_id" select="PRE_ALG_ID"/>
                                        <xsl:with-param name="p_post_alg_id" select="POST_ALG_ID"/>
                                        <xsl:with-param name="p_ifd_schema"
                                             select="//RIFD/IFD_SCHEMA"/>
                                        <xsl:with-param name="p_ifd_schema_doc_name"
                                              select="//RIFD/IFD_SCHEMA_DOC_NAME" />
                </xsl:call-template>
            </div>
            <!-- Get Segments for Result IFD -->
            <xsl:for-each select="RIFD_SEGS/RIFD_SEG">
                <xsl:variable name="this_ifd_seg_id" select="IFD_SEG_ID"/>
                <div class="section">
                    <a name="{$this_ifd_id}{$this_ifd_ver}{IFD_SEG_ID}">
                        <h2>IFD Segment: <xsl:value-of select="$this_ifd_id"/>|<xsl:value-of select="$this_ifd_ver"/>|<xsl:value-of select="$this_ifd_seg_id"/>
                        </h2>
                    </a>
                    <xsl:call-template name="SHOW_IFD_SEG_DESCR">
                        <xsl:with-param name="p_descr" select="IFD_SEG_DESCR/IFD_SEG_DESCR"/>
                        <xsl:with-param name="p_blk_alg_id" select="BLK_ALG_ID"/>
                        <xsl:with-param name="p_blk_alg_eval_cd" select="BLK_ALG_EVAL_CD"/>
                        <xsl:with-param name="p_proc_alg_id" select="PROC_ALG_ID"/>
                        <xsl:with-param name="p_pre_alg_id" select="PRE_ALG_ID"/>
                        <xsl:with-param name="p_post_alg_id" select="POST_ALG_ID"/>
                    </xsl:call-template>
                </div>
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
                        <xsl:for-each select="//Event[EVT_ID = $this_evt_id]/SYSTEM/uc_eos/uc_eo/RIFDS/RIFD[IFD_ID=$this_ifd_id and IFD_VER=$this_ifd_ver]/RIFD_MAPS/RIFD_MAP[IFD_SEG_ID=$this_ifd_seg_id]">
                            <tr class="my-td">
                                <xsl:variable name="this_data_lay_cd" select="ancestor::RIFD/DATA_LAY_CD"/>
                                <td>
                                    <xsl:value-of select="IFD_FLD_ID"/>
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
                                    <xsl:value-of select="IFD_FLD_LEN"/>
                                </td>
                                <td>
                                    <xsl:value-of select="IFD_FLD_MAX_CHARS"/>
                                </td>
                                <td>
                                    <xsl:value-of select="FLD_FMT"/>
                                </td>
                                <td>
                                    <xsl:value-of select="REMAPPED_EXPR"/>
                                </td>
                                <td>
                                    <xsl:value-of select="OVERSTACK_FLG"/>
                                </td>
                                <td>
                                    <xsl:value-of select="CREATE_EXPR"/>
                                </td>
                                <td>
                                    <xsl:value-of select="CHANGE_EXPR"/>
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
                        </xsl:for-each>
                    </table>
                </div>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="GEN_IIFD_SEGMENT_DATA">
        <h1>
  Inbound IFD Definition Info
</h1>
        <h2>IFD Name: <xsl:value-of select="//IFD_DEF/IFD_ID"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="//IFD_DEF/IFD_VER"/>
        </h2>
        <xsl:for-each select="//IFD_DEF/IFD_SEGS/IFD_SEG">
            <xsl:variable name="this_ifd_seg_id" select="IFD_SEG_ID"/>
            <h2>
                <a name="{$this_ifd_seg_id}">
       Segment: <xsl:value-of select="$this_ifd_seg_id"/>
                </a>
            </h2>
            <table>
                <tr>
                    <td>
                        <b>Field</b>
                    </td>
                    <td>
                        <b>Type</b>
                    </td>
                </tr>
            </table>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="GEN_POST_PROCESSING">
        <br/>
        <div class="copyright">
    Copyright &#169; 2008 RedPrairie&#174;.  All rights reserved.
  </div>

<script>
<![CDATA[
var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var content = this.nextElementSibling;
    if (content.style.maxHeight){
      content.style.maxHeight = null;
    } else {
      content.style.maxHeight = content.scrollHeight + "px";
    } 
  });
}
]]>
</script>

    </xsl:template>
    
    <xsl:template name="SHOW_IFD_SEG_DESCR">
        <xsl:param name="p_descr"/>
        <xsl:param name="p_blk_alg_id"/>
        <xsl:param name="p_blk_alg_eval_cd"/>
        <xsl:param name="p_proc_alg_id"/>
        <xsl:param name="p_pre_alg_id"/>
        <xsl:param name="p_post_alg_id"/>
        
<div class="indent1">
  <table class="my-table" width="90%">
  <col width="196"></col>
  <tr>
    <td class="my-th">IFD Segment Description</td>
    <td class="my-td"><xsl:call-template name="FORMAT_DESCR">
                <xsl:with-param name="p_descr" select="$p_descr"/>
            </xsl:call-template></td>
  </tr>
  <tr>
    <td class="my-th">Blocking Algorithm</td>
    <td class="my-td"><xsl:value-of select="$p_blk_alg_id"/></td>
  </tr>
  <tr>
    <td class="my-th">Evaluation Code</td>
    <td class="my-td"><xsl:value-of select="$p_blk_alg_eval_cd"/></td>
  </tr>
  <tr>
    <td class="my-th">Pre Algorithm</td>
    <td class="my-td"><xsl:value-of select="$p_pre_alg_id"/></td>
  </tr>
  <tr>
    <td class="my-th">Processing Algorithm</td>
    <td class="my-td"><xsl:value-of select="$p_proc_alg_id"/></td>
  </tr>
  <tr>
    <td class="my-th">Post Algorithm</td>
    <td class="my-td"><xsl:value-of select="$p_post_alg_id"/></td>
  </tr>
</table>
</div>
            </xsl:template>
    
    <xsl:template name="SHOW_IFD_DESCR">
        <xsl:param name="p_descr"/>
        <xsl:param name="p_group"/>
                <xsl:param name="p_ifd_id"/>
                <xsl:param name="p_ifd_ver"/>
                <xsl:param name="p_ifd_schema"/>
                <xsl:param name="p_pre_alg_id"/>
                <xsl:param name="p_post_alg_id"/>
                <xsl:param name="p_ifd_schema_doc_name"/>
                

<div class="indent1">
  <table  class="my-table" width="90%">
    <col width="196"></col>
    <tr>
      <td class="my-th">IFD Description</td>
      <td class="my-td">
         <xsl:call-template name="FORMAT_DESCR">
            <xsl:with-param name="p_descr" select="$p_descr"/>
         </xsl:call-template></td>
    </tr>
    <tr>
      <td class="my-th">Group</td>
      <td class="my-td"><xsl:value-of select="$p_group"/></td>
    </tr>
    <tr>
      <td class="my-th">Pre Algorithm</td>
      <td class="my-td"><xsl:value-of select="$p_pre_alg_id"/></td>
    </tr>
    <tr>
      <td class="my-th">Post Algorithm</td>
      <td class="my-td"><xsl:value-of select="$p_post_alg_id"/></td>
    </tr>
  </table>

  <p/>
  <xsl:if test="$p_ifd_schema='W3C'">
     <a class="link" href="{$p_ifd_schema_doc_name}">IFD XML W3C Schema</a>
  </xsl:if>

  <xsl:if test="$p_ifd_schema='XDR'">
     <a class="link" href="{$p_ifd_schema_doc_name}">IFD XML XDR Schema</a>
  </xsl:if>
   
</div>
    
    </xsl:template>
    
    <xsl:template name="SHOW_IFD_FLD_DESCR">
        <xsl:param name="p_descr"/>
        <xsl:call-template name="FORMAT_DESCR">
            <xsl:with-param name="p_descr" select="$p_descr"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="SHOW_VALIDATION_CMNT">
        <xsl:param name="p_descr"/>
        <xsl:call-template name="FORMAT_DESCR">
            <xsl:with-param name="p_descr" select="$p_descr"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="SHOW_DEFAULT_VAL_CMNT">
        <xsl:param name="p_descr"/>
        <xsl:call-template name="FORMAT_DESCR">
            <xsl:with-param name="p_descr" select="$p_descr"/>
        </xsl:call-template>
    </xsl:template>
    <!--  Substitute each new line in the description with <br></br>.
      Otherwise, we will loose line breaks in our descriptions.
-->
    <xsl:template name="FORMAT_DESCR">
        <xsl:param name="p_descr"/>
        <xsl:choose>
            <xsl:when test="contains($p_descr,'&#xA;')">
                <xsl:value-of select="substring-before($p_descr,'&#xA;')"/>
                <xsl:value-of select="concat('&lt;','br','&gt;')"/>
                <xsl:call-template name="FORMAT_DESCR">
                    <xsl:with-param name="p_descr" select="substring-after($p_descr,'&#xA;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$p_descr"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
