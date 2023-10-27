publish data 
where table = 'pck_zone'
and uc_inhibit_version_control = '1'
and pck_zone_cod = '@pck_zone_cod@'
and bldg_id = '@bldg_id@'
and wh_id = '@wh_id@'
and atecod = '@atecod@'
and ctngrp = '@ctngrp@'
and dtlflg = '@dtlflg@'
and subflg = '@subflg@'
and lodflg = '@lodflg@'
and pck_steal_flg = '@pck_steal_flg@'
and start_pal_flg = '@start_pal_flg@'
and pipflg = '@pipflg@'
and err_loc_invsts_flg = '@err_loc_invsts_flg@'
and rf_pcklst_dsp = '@rf_pcklst_dsp@'
and rf_suppress_qty = '@rf_suppress_qty@'
and mix_lotsts_alloc_flg = '@mix_lotsts_alloc_flg@'
and sum_count_bck_flg = '@sum_count_bck_flg@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and grp_pck = '@grp_pck@'
and lngdsc = '@lngdsc@'
|
{
    [
    select pck_zone_id 
    from UCDM_LOC_00300_PCK_ZONE
    where 1=1 
    and pck_zone_cod = @pck_zone_cod
    and wh_id = @wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {    
        create pick zone where uc_called_from_mload = '1'
    }
    else
	{
        change pick zone where uc_called_from_mload = '1'
	}
}