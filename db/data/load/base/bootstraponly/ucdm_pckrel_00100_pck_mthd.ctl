publish data 
where table = 'pck_mthd'
and uc_inhibit_version_control = '1'
and pck_mthd_nam = '@pck_mthd_nam@'
and wh_id = '@wh_id@'
and list_flg = '@list_flg@'
and ctn_flg = '@ctn_flg@'
and skip_pick_valdt = '@skip_pick_valdt@'
and inline_rpl_flg = '@inline_rpl_flg@'
and rsv_pck_rel = '@rsv_pck_rel@'
and spcfc_cs_flg = '@spcfc_cs_flg@'
and mix_cs_flg = '@mix_cs_flg@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and lngdsc = '@lngdsc@'
|
{
    if ( @wh_id = 'WMD1' )
        [
        select wh_id
        from wh
        order by 1
        ]
    |
    [
    select pck_mthd_id 
    from UCDM_PCKREL_00100_PCK_MTHD 
    where 1=1 
    and pck_mthd_nam = @pck_mthd_nam
    and wh_id = @wh_id
    ] catch(-1403, 510)
    |
    if ( @? != 0 )
    {    
        create pick method where uc_called_from_mload = '1'
    }
    else
    {
        change pick method where uc_called_from_mload = '1'
	}
}
