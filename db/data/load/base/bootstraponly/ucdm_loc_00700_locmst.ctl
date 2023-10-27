publish data 
where table = 'locmst'
and uc_inhibit_version_control = '1'
and stoloc = '@stoloc@'
and wh_id = '@wh_id@'
and arecod = '@arecod@'
and loccod = '@loccod@'
and locsts = '@locsts@'
and velzon = '@velzon@'
and aisle_id = '@aisle_id@'
and trvseq = '@trvseq@'
and sto_seq = '@sto_seq@'
and rescod = '@rescod@'
and bay = '@bay@'
and lvl = '@lvl@'
and locpos = '@locpos@'
and lochgt = '@lochgt@'
and loclen = '@loclen@'
and locwid = '@locwid@'
and dck_acc_cod = '@dck_acc_cod@'
and locvrc = '@locvrc@'
and maxqvl = '@maxqvl@'
and curqvl = '@curqvl@'
and pndqvl = '@pndqvl@'
and trfpct = '@trfpct@'
and erfpct = '@erfpct@'
and esc_type = '@esc_type@'
and esc_thr = '@esc_thr@'
and useflg = '@useflg@'
and stoflg = '@stoflg@'
and pckflg = '@pckflg@'
and repflg = '@repflg@'
and asgflg = '@asgflg@'
and cipflg = '@cipflg@'
and cntseq = '@cntseq@'
and numcnt = '@numcnt@'
and abccod = '@abccod@'
and cntdte = '@cntdte@'
and devcod = '@devcod@'
and lokcod = '@lokcod@'
and locacc = '@locacc@'
and voc_chkdgt = '@voc_chkdgt@'
and voc_chkdgt_2 = '@voc_chkdgt_2@'
and voc_chkdgt_3 = '@voc_chkdgt_3@'
and lstdte = '@lstdte@'
and lstcod = '@lstcod@'
and lst_usr_id = '@lst_usr_id@'
and slotseq = '@slotseq@'
and perm_asgflg = '@perm_asgflg@'
and cnt_zone_id = '@cnt_zone_id@'
and pck_zone_id = '@pck_zone_id@'
and sto_zone_id = '@sto_zone_id@'
and mov_zone_id = '@mov_zone_id@'
and wrk_zone_id = '@wrk_zone_id@'
and loc_typ_id = '@loc_typ_id@'
and of_lvl_unit = '@of_lvl_unit@'
and section = '@section@'
and x = '@x@'
and y = '@y@'
and z = '@z@'
and attr1 = '@attr1@'
and attr2 = '@attr2@'
and attr3 = '@attr3@'
and attr4 = '@attr4@'
and attr5 = '@attr5@'
and basepoint_id = '@basepoint_id@'
and top_left_x = '@top_left_x@'
and top_left_y = '@top_left_y@'
and top_right_x = '@top_right_x@'
and top_right_y = '@top_right_y@'
and bottom_left_x = '@bottom_left_x@'
and bottom_left_y = '@bottom_left_y@'
and bottom_right_x = '@bottom_right_x@'
and bottom_right_y = '@bottom_right_y@'
and border_pad = '@border_pad@'
and auto_mov_flg = '@auto_mov_flg@'
and slot_id = '@slot_id@'
and def_maxqvl = '@def_maxqvl@'
and u_version = '@u_version@'
and ateseq = '@ateseq@'
and atedte = '@atedte@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and cntbck_ena_flg = '@cntbck_ena_flg@'
and prdlin = '@prdlin@'
and stgloc = '@stgloc@'
and rcv_rescod = '@rcv_rescod@'
and pal_stck_rst = '@pal_stck_rst@'
and maxwgt = '@maxwgt@'
and lvl_typ_id = '@lvl_typ_id@'
and billing_flg = '@billing_flg@'
and prtadr = '@prtadr@'
and lbl_prtadr = '@lbl_prtadr@'
and min_lvl_unit = '@min_lvl_unit@'
and cnt_zone_cod = '@cnt_zone_cod@'
and pck_zone_cod = '@pck_zone_cod@'
and sto_zone_cod = '@sto_zone_cod@'
and mov_zone_cod = '@mov_zone_cod@'
and wrkzon = '@wrkzon@'
and loc_typ = '@loc_typ@'
and lvl_type_name = '@lvl_type_name@'
and loc_typ_cat = '@loc_typ_cat@'
|
{
    if ( @wh_id = 'WMD1' )
        [
        select wh_id 
        from wh
        order by 1
        ]
    |
    if ( @loc_typ_cat is not null )
        [
        select x.*
        from 
        (
            select loc_typ_id
            from loc_typ
            where loc_typ_cat = @loc_typ_cat
            and wh_id = @wh_id
            and rownum < 999999
            order by stgflg desc, loc_typ
        ) x
        where rownum < 2
        ]
        catch (-1403,510)
    |
    if (@cnt_zone_cod is not null or @cnt_zone_cod != '')
    {
        [
        select cnt_zone_id 
        from cntzon 
        where cnt_zone_cod = @cnt_zone_cod 
        and wh_id = @wh_id
        ] 
        catch(-1403, 510) 
    }
    |
    if (@pck_zone_cod is not null or @pck_zone_cod != '')
    {
        [
        select pck_zone_id 
        from pck_zone 
        where pck_zone_cod = @pck_zone_cod 
        and wh_id = @wh_id
        ] 
        catch(-1403, 510) 
    }
    |
    if (@sto_zone_cod is not null or @sto_zone_cod != '')
    {
        [
        select sto_zone_id 
        from sto_zone 
        where sto_zone_cod = @sto_zone_cod 
        and wh_id = @wh_id
        ]
        catch(-1403, 510) 
    }
    |
    if (@mov_zone_cod is not null or @mov_zone_cod != '')
    {
        [
        select mov_zone_id 
        from mov_zone 
        where mov_zone_cod = @mov_zone_cod 
        and wh_id = @wh_id
        ] 
        catch(-1403, 510) 
    }
    |
    if (@wrkzon is not null or @wrkzon != '')
    {
        [
        select wrk_zone_id 
        from zonmst 
        where wrkzon = @wrkzon 
        and wh_id = @wh_id
        ] 
        catch(-1403, 510) 
    }
    |
    if (@loc_typ is not null or @loc_typ != '')
    {
        [
        select loc_typ_id 
        from loc_typ 
        where loc_typ = @loc_typ 
        and wh_id = @wh_id
        ]
        catch(-1403, 510) 
    }
    |
    if (@lvl_type_name is not null or @lvl_type_name != '')
    {
        [
        select lvl_typ_id 
        from lvl_typ 
        where lvl_type_name = @lvl_type_name
        and wh_id = @wh_id
        ]
        catch(-1403, 510) 
    }
    |
    [
    select count(*) cnt 
    from UCDM_LOC_00700_LOCMST 
    where 1=1 
    and stoloc = @stoloc
    and wh_id = @wh_id 
    ] 
    |
    if (@cnt = 0)
    {
        [
          select 'x' 
            from aremst 
           where arecod = @arecod 
             and wh_id = @wh_id
        ] catch(-1403, 510)
        |
        if(@? = -1403 or @? = 510)
        {
           create area 
            where arecod = @arecod
              and wh_id = @wh_id
              and lngdsc = @arecod
              and short_dsc = @arecod
              and logic_flg =0 
              and bldg_id = 'B1'
        }
        |
        create location 
        where uc_called_from_mload = '1' 
    }
    else 
    {
        change location 
        where uc_called_from_mload = '1' 
    }
}