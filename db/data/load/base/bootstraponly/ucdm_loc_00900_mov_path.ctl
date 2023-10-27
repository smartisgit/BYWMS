publish data 
where table = 'mov_path'
and uc_inhibit_version_control = '1'
and src_mov_zone_id = '@src_mov_zone_id@'
and dst_mov_zone_id = '@dst_mov_zone_id@'
and lodlvl = '@lodlvl@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and mov_zone_src = '@mov_zone_src@'
and mov_zone_dst = '@mov_zone_dst@'
and mov_path_name = '@mov_path_name@'
and mov_zone_src_wh_id = '@mov_zone_src_wh_id@'
and mov_zone_dst_wh_id = '@mov_zone_dst_wh_id@'
|
{
    [
    select src_mov_zone_id,
	       dst_mov_zone_id,
	       mov_zone_src,
           mov_zone_dst,
           mov_path_name		   
    from UCDM_LOC_00900_MOV_PATH
    where 1=1 
    and mov_zone_src = @mov_zone_src
	and mov_zone_src_wh_id = @mov_zone_src_wh_id
	and mov_zone_dst = @mov_zone_dst
	and mov_zone_dst_wh_id = @mov_zone_dst_wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {   
		[select mov_zone_id src_mov_zone_id from mov_zone where mov_zone_cod = @mov_zone_src and wh_id = @mov_zone_src_wh_id]catch(-1403)
		|
	    [select mov_zone_id dst_mov_zone_id from mov_zone where mov_zone_cod = @mov_zone_dst and wh_id = @mov_zone_dst_wh_id]catch(-1403)
		|
		publish data where dst_mov_zone_id = nvl(@dst_mov_zone_id, '-10000')
		|
		publish data where mov_path_name = @mov_path_name || 'WH'
		|
        create movement path where uc_called_from_mload = '1'
    }
    else
	{
        change movement path where uc_called_from_mload = '1'
	}
}