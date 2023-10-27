publish data 
where table = 'mov_zone_nxtmov'
and uc_inhibit_version_control = '1'
and src_mov_zone_id = '@src_mov_zone_id@'
and dst_mov_zone_id = '@dst_mov_zone_id@'
and lodlvl = '@lodlvl@'
and seqnum = '@seqnum@'
and oprcod = '@oprcod@'
and pricod = '@pricod@'
and u_version = '@u_version@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and src_mov_zone_cod = '@src_mov_zone_cod@'
and dst_mov_zone_cod = '@dst_mov_zone_cod@'
and src_mov_zone_cod_desc = '@src_mov_zone_cod_desc@'
and dst_mov_zone_cod_desc = '@dst_mov_zone_cod_desc@'
and src_mov_zone_wh_id = '@src_mov_zone_wh_id@'
and dst_mov_zone_wh_id = '@dst_mov_zone_wh_id@'
|
{
    [
    select src_mov_zone_id,
	       dst_mov_zone_id,
	       src_mov_zone_cod,
           dst_mov_zone_cod,
           src_mov_zone_cod_desc,
           dst_mov_zone_cod_desc		   
    from UCDM_LOC_00800_MOV_ZONE_NXTMOV
    where 1=1 
    and src_mov_zone_cod = @src_mov_zone_cod
	and (dst_mov_zone_cod = @dst_mov_zone_cod
	 or dst_mov_zone_cod_desc = 'Any zone')
	and src_mov_zone_wh_id = @src_mov_zone_wh_id
	and (dst_mov_zone_wh_id = @dst_mov_zone_wh_id or dst_mov_zone_wh_id is null)
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {   
		[select mov_zone_id src_mov_zone_id from mov_zone where mov_zone_cod = @src_mov_zone_cod and wh_id = @src_mov_zone_wh_id]catch(-1403)
		|
	    [select mov_zone_id dst_mov_zone_id from mov_zone where mov_zone_cod = @dst_mov_zone_cod and wh_id = @dst_mov_zone_wh_id]catch(-1403)
		|
		publish data where dst_mov_zone_id = nvl(@dst_mov_zone_id, '-10000')
		|
        create next move for move zone where uc_called_from_mload = '1'
    }
    else
	{
        change next move for move zone where uc_called_from_mload = '1'
	}
}