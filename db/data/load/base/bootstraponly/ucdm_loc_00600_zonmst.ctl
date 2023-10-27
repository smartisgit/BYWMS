publish data 
where table = 'zonmst'
and uc_inhibit_version_control = '1'
and wrkzon = '@wrkzon@'
and wh_id = '@wh_id@'
and bldg_id = '@bldg_id@'
and wrkare = '@wrkare@'
and maxdev = '@maxdev@'
and oosflg = '@oosflg@'
and trvseq = '@trvseq@'
and prithr = '@prithr@'
and maxprithr = '@maxprithr@'
and pck_exp_are = '@pck_exp_are@'
and moddte = '@moddte@'
and mod_usr_id = '@mod_usr_id@'
and u_version = '@u_version@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and lngdsc = '@lngdsc@'
|
{
    [
    select wrk_zone_id 
    from UCDM_LOC_00600_ZONMST
    where 1=1 
    and wrkzon = @wrkzon
    and wh_id = @wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {    
        create work zone where uc_called_from_mload = '1'
    }
    else
	{
        change work zone where uc_called_from_mload = '1'
	}
}