publish data 
where table = 'pcklst_rule'
and uc_inhibit_version_control = '1'
and pcklst_rule_name = '@pcklst_rule_name@'
and client_id = '@client_id@'
and re_list_flg = '@re_list_flg@'
and allow_split_flg = '@allow_split_flg@'
and list_typ = '@list_typ@'
and one_pass_only = '@one_pass_only@'
and assign_slot_flg = '@assign_slot_flg@'
and asset_typ = '@asset_typ@'
and valid_flg = '@valid_flg@'
and cnf_mtused_prt = '@cnf_mtused_prt@'
and cmdtxt = '@cmdtxt@'
and opr_cod = '@opr_cod@'
and pick_ord_by = '@pick_ord_by@'
and max_start_picks = '@max_start_picks@'
and drop_at_wrkzone_change = '@drop_at_wrkzone_change@'
and frc_pickup_prev = '@frc_pickup_prev@'
and rsm_lst_pck_prev_opr = '@rsm_lst_pck_prev_opr@'
and cmb_list_flg = '@cmb_list_flg@'
and lngdsc = '@lngdsc@'
and prevent_pck_cons = '@prevent_pck_cons@'
and pick_to_lvl = '@pick_to_lvl@'     
and wa_fit_cri = '@wa_fit_cri@'      
and max_assets = '@max_assets@'      
and wh_id = '@wh_id@'
and uc_change_allowed = '1'
|
{
    if ( @wh_id = 'WMD1' )
        [
        select distinct wh.wh_id,
               nvl(client_wh.client_id, @client_id) client_id
          from wh
          left
          join client_wh
            on wh.wh_id = client_wh.wh_id
         order by 1
        ]
    |
    [
    select pcklst_rule_id 
    from ucdm_pcklst_00100_pcklst_rule 
    where 1=1 
    and pcklst_rule_name = @pcklst_rule_name
    and wh_id = @wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {   
        create pick list rule where uc_called_from_mload = '1'
        |
        [
        update pcklst_rule
        set valid_flg = 1
        where pcklst_rule_id = @pcklst_rule_id
        ]
        catch (-1403,510)
    }
    else if ( @uc_change_allowed = '1' )
        change pick list rule where uc_called_from_mload = '1'
}
