publish data 
where table = 'pck_zone_invsts'
and uc_inhibit_version_control = '1'
and pck_zone_id = '@pck_zone_id@'
and invsts = '@invsts@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and pck_zone_cod = '@pck_zone_cod@'
and wh_id = '@wh_id@'
|
{
    [
    select pck_zone_id 
    from pck_zone
    where 1=1 
    and pck_zone_cod = @pck_zone_cod
	and wh_id = @wh_id
    ] catch(-1403, 510)
	|
	[
    select count(*) cnt 
    from pck_zone_invsts
    where 1=1 
    and pck_zone_id = @pck_zone_id
	and invsts = @invsts
    ] catch(-1403, 510)
	|
    if ( @cnt = 0 )
    {    
        create record where table = @table and uc_called_from_mload = '1'
    }
	else
	{
		create record where table = @table and uc_called_from_mload = '1'
	}
}