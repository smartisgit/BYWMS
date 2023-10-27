publish data 
where table = 'mov_path_dtl'
and uc_inhibit_version_control = '1'
and src_mov_zone_id = '@src_mov_zone_id@'
and dst_mov_zone_id = '@dst_mov_zone_id@'
and lodlvl = '@lodlvl@'
and hopseq = '@hopseq@'
and hop_mov_zone_id = '@hop_mov_zone_id@'
and move_method = '@move_method@'
and cri_id = '@cri_id@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and src_mov_zone_cod = '@src_mov_zone_cod@'
and dst_mov_zone_cod = '@dst_mov_zone_cod@'
and hop_mov_zone_cod = '@hop_mov_zone_cod@'
and src_mov_zone_cod_wh_id = '@src_mov_zone_cod_wh_id@'
and dst_mov_zone_cod_wh_id = '@dst_mov_zone_cod_wh_id@'
and hop_mov_zone_cod_wh_id = '@hop_mov_zone_cod_wh_id@'
|
{
    [
    select src_mov_zone_id,
	       dst_mov_zone_id,
		   hop_mov_zone_id,
		   lodlvl,
		   hopseq,
	       src_mov_zone_cod,
           dst_mov_zone_cod,
           hop_mov_zone_cod		   
    from UCDM_LOC_00910_MOV_PATH_DTL
    where 1=1 
    and src_mov_zone_cod = @src_mov_zone_cod
	and dst_mov_zone_cod = @dst_mov_zone_cod
	and hop_mov_zone_cod = @hop_mov_zone_cod
	and src_mov_zone_cod_wh_id = @src_mov_zone_cod_wh_id
	and dst_mov_zone_cod_wh_id = @dst_mov_zone_cod_wh_id
	and hop_mov_zone_cod_wh_id = @hop_mov_zone_cod_wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {   
		[select mov_zone_id src_mov_zone_id from mov_zone where mov_zone_cod = @src_mov_zone_cod and wh_id = @src_mov_zone_cod_wh_id]catch(-1403)
		|
	    [select mov_zone_id dst_mov_zone_id from mov_zone where mov_zone_cod = @dst_mov_zone_cod and wh_id = @dst_mov_zone_cod_wh_id]catch(-1403)
		|
	    [select mov_zone_id hop_mov_zone_id from mov_zone where mov_zone_cod = @hop_mov_zone_cod and wh_id = @hop_mov_zone_cod_wh_id]catch(-1403)
		|
        create movement path detail where uc_called_from_mload = '1'
    }
    else
	{
        change movement path detail where uc_called_from_mload = '1'
	}
}