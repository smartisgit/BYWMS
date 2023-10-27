publish data 
where table = 'sto_zone'
and uc_inhibit_version_control = '1'
and sto_zone_cod = '@sto_zone_cod@'
and bldg_id = '@bldg_id@'
and wh_id = '@wh_id@'
and conflg = '@conflg@'
and con_pal_flg = '@con_pal_flg@'
and fifflg = '@fifflg@'
and pckcod = '@pckcod@'
and prox_put_cod = '@prox_put_cod@'
and rnwl_sto_flg = '@rnwl_sto_flg@'
and set_locsts_flg = '@set_locsts_flg@'
and set_maxqvl_flg = '@set_maxqvl_flg@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and lngdsc = '@lngdsc@'
|
{
    [
    select sto_zone_id 
    from UCDM_LOC_00400_STO_ZONE
    where 1=1 
    and sto_zone_cod = @sto_zone_cod
    and wh_id = @wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {    
        create storage zone where uc_called_from_mload = '1'
    }
    else
	{
        change storage zone where uc_called_from_mload = '1'
	}
}