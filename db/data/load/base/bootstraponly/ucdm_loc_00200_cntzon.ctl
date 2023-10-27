publish data 
where table = 'cntzon'
and wh_id = '@wh_id@'
and cnt_zone_cod = '@cnt_zone_cod@'
and bldg_id = '@bldg_id@'
and cntflg = '@cntflg@'
and cnzamt = '@cnzamt@'
and cnzcod = '@cnzcod@'
and icnflg = '@icnflg@'
and lpncntflg = '@lpncntflg@'
and lpncnt_lodlvl = '@lpncnt_lodlvl@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and lngdsc = '@lngdsc@'
|
{
    [
    select cnt_zone_id 
    from UCDM_LOC_00200_CNTZON
    where 1=1 
    and cnt_zone_cod = @cnt_zone_cod
    and wh_id = @wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {    
        create count zone where uc_called_from_mload = '1'
    }
    else
	{
        change count zone where uc_called_from_mload = '1'
	}
}