publish data 
where table = 'loc_typ'
and uc_inhibit_version_control = '1'
and loc_typ = '@loc_typ@'
and loc_typ_cat = '@loc_typ_cat@'
and wh_id = '@wh_id@'
and adjflg = '@adjflg@'
and autclr_prcare = '@autclr_prcare@'
and def_rcv_invsts = '@def_rcv_invsts@'
and dispatch_flg = '@dispatch_flg@'
and dstr_flg = '@dstr_flg@'
and dstr_pck_ctn_flg = '@dstr_pck_ctn_flg@'
and dstr_pck_pal_flg = '@dstr_pck_pal_flg@'
and dstr_sug_ctn_flg = '@dstr_sug_ctn_flg@'
and dstr_sug_pal_flg = '@dstr_sug_pal_flg@'
and expflg = '@expflg@'
and ftl_flg = '@ftl_flg@'
and fwiflg = '@fwiflg@'
and lpn_mix_flg = '@lpn_mix_flg@'
and mix_shprcv_flg = '@mix_shprcv_flg@'
and pck_to_sto_flg = '@pck_to_sto_flg@'
and pdflg = '@pdflg@'
and praflg = '@praflg@'
and prd_stgflg = '@prd_stgflg@'
and prod_flg = '@prod_flg@'
and put_to_sto_flg = '@put_to_sto_flg@'
and rcv_dck_flg = '@rcv_dck_flg@'
and rcv_stgflg = '@rcv_stgflg@'
and rcvwo_non_fwiflg = '@rcvwo_non_fwiflg@'
and rdtflg = '@rdtflg@'
and share_loc_flg = '@share_loc_flg@'
and shp_dck_flg = '@shp_dck_flg@'
and loc_ovrd_flg = '@loc_ovrd_flg@'
and shpflg = '@shpflg@'
and sigflg = '@sigflg@'
and stgflg = '@stgflg@'
and sto_trlr_flg = '@sto_trlr_flg@'
and stoare_flg = '@stoare_flg@'
and wip_expflg = '@wip_expflg@'
and wip_supflg = '@wip_supflg@'
and wipflg = '@wipflg@'
and xdaflg = '@xdaflg@'
and yrdflg = '@yrdflg@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and rem_lpn_flg = '@rem_lpn_flg@'
and lngdsc = '@lngdsc@'
|
{
    [
    select loc_typ_id 
    from UCDM_LOC_00100_LOC_TYP
    where 1=1 
    and loc_typ = @loc_typ
    and wh_id = @wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {    
        create wm location type where uc_called_from_mload = '1'
    }
    else
	{
        change wm location type where uc_called_from_mload = '1'
	}
}