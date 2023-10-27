publish data 
where table = 'mov_path_cri'
and uc_inhibit_version_control = '1'
and seqnum = '@seqnum@'
and wh_id = '@wh_id@'
and grpopr = '@grpopr@'
and table_nam = '@table_nam@'
and field_name = '@field_name@'
and operator = '@operator@'
and value = '@value@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and lngdsc = '@lngdsc@'
|
{
    [
    select cri_id, seqnum, wh_id		   
    from UCDM_LOC_002000_MOV_PATH_CRI
    where 1=1 
    and lngdsc = @lngdsc
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {    
        create movement path criteria where uc_called_from_mload = '1'
    }
    else
	{
        change movement path criteria where uc_called_from_mload = '1'
	}
}