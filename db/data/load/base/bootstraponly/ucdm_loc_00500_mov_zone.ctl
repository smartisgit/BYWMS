publish data 
where table = 'mov_zone'
and uc_inhibit_version_control = '1'
and mov_zone_cod = '@mov_zone_cod@'
and wh_id = '@wh_id@'
and bldg_id = '@bldg_id@'
and clr_dstloc_flg = '@clr_dstloc_flg@'
and split_trn = '@split_trn@'
and lbl_on_split = '@lbl_on_split@'
and ovrpck_rpl_flg = '@ovrpck_rpl_flg@'
and cap_fill_flg = '@cap_fill_flg@'
and def_rplcfg_invsts = '@def_rplcfg_invsts@'
and def_rplcfg_maxunt = '@def_rplcfg_maxunt@'
and def_rplcfg_minunt = '@def_rplcfg_minunt@'
and def_rplcfg_pctflg = '@def_rplcfg_pctflg@'
and dyn_slot_flg = '@dyn_slot_flg@'
and recalc_putaway = '@recalc_putaway@'
and max_mhu_deposit = '@max_mhu_deposit@'
and dstr_excp_loc = '@dstr_excp_loc@'
and bto_kit_dep_flg = '@bto_kit_dep_flg@'
and rcv_pltbld_flg = '@rcv_pltbld_flg@'
and dstr_audit = '@dstr_audit@'
and auto_close_flg = '@auto_close_flg@'
and prompt_for_part_distr = '@prompt_for_part_distr@'
and rdtflg = '@rdtflg@'
and dyn_rplcfg_flg = '@dyn_rplcfg_flg@'
and auto_cancel_pick = '@auto_cancel_pick@'
and mix_on_unlock_flg = '@mix_on_unlock_flg@'
and alloc_max_uom_rpl_flg = '@alloc_max_uom_rpl_flg@'
and autocls_ship_flg = '@autocls_ship_flg@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and qty_ver_only_flg = '@qty_ver_only_flg@'
and pre_stage_flg = '@pre_stage_flg@'
and thresh_split_flg = '@thresh_split_flg@'
and rpl_split_disp_cas_flg = '@rpl_split_disp_cas_flg@'
and lngdsc = '@lngdsc@'
|
{
    if ( @wh_id = 'WMD1' )
        [
        select wh_id
        from wh
        order by 1
        ]
    |
    {
        if ( @bldg_id = 'ANY' )
            [
            select bldg_id
            from bldg_mst
            where wh_id = @wh_id
            and rownum < 2
            ]
        |
        {
            [
            select mov_zone_id 
            from UCDM_LOC_00500_MOV_ZONE
            where 1=1 
            and mov_zone_cod = @mov_zone_cod
            and wh_id = @wh_id
            ] 
            catch(-1403, 510)
            |
            if ( @? != 0 )
            {    
                create movement zone where uc_called_from_mload = '1'
            }
            else
	    {
                change movement zone where uc_called_from_mload = '1'
	    }
            ;
            /* 
             * we have a special movement zone for rule based selection.  We need location for it 
             */
            if ( @mov_zone_cod = 'UC_RULE_BASEDS' )
            {
                [
                select 1
                from locmst
                where wh_id = @wh_id
                and stoloc = 'UC_RULE_BASEDSLOC01'
                ]
                catch (-1403,510)
                |
                if ( @? != 0 )
                {
                    [
                    select mov_zone_id 
                    from UCDM_LOC_00500_MOV_ZONE
                    where wh_id = @wh_id
                    and mov_zone_cod = @mov_zone_cod
                    ]
                    catch (-1403,510)
                    |
                    [
                    select loc_typ_id
                    from loc_typ
                    where wh_id = @wh_id
                    and loc_typ = 'SSTG'
                    ]
                    catch (-1403,510)
                    |
                    if ( @loc_typ_id and @mov_zone_id )
                        create location
                        where stoloc = 'UC_RULE_BASEDSLOC01'
                        and loccod = 'P'
                        and arecod = 'OSTG'
                        and velzon = 'A'
                        and useflg = 0
                        catch (2003,802-1403,512,-1)
                }
            }
        }
    }
}