publish data 
where uc_inhibit_version_control = '1'
and bldg_id = '@bldg_id@'
and srtseq = '@srtseq@'
and pck_mthd_id = '@pck_mthd_id@'
and pck_zone_id = '@pck_zone_id@'
and lodlvl = '@lodlvl@'
and uomcod = '@uomcod@'
and reg_uom = '@reg_uom@'
and thresh_flg = '@thresh_flg@'
and cstms_bond_flg = '@cstms_bond_flg@'
and dty_stmp_flg = '@dty_stmp_flg@'
and alloc_grp_nam = '@alloc_grp_nam@'
and loc_cap_pck_pct = '@loc_cap_pck_pct@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and pck_zone_cod = '@pck_zone_cod@'
and pck_mthd_nam = '@pck_mthd_nam@'
and lngdsc = '@lngdsc@'
and wh_id = '@wh_id@'
|
{
  [select alloc_search_path_id alloc_search_path_id
   from UCDM_UALLOC_00100_ALOC_SRH_PTH 
  where 1=1 
    and lngdsc = @lngdsc 
    and wh_id = @wh_id 
  ] catch (-1403,510) 
  |
  [select pck_zone_id 
   from pck_zone 
   where pck_zone_cod = @pck_zone_cod 
   and wh_id = @wh_id
  ] catch(-1403, 510)
  |
  [select pck_mthd_id 
   from pck_mthd 
   where pck_mthd_nam = @pck_mthd_nam 
      and wh_id = @wh_id
  ] catch(-1403, 510)
  |
  [select distinct alloc_search_path_rule_id old_alloc_search_path_rule_id 
   from UCDM_UALLOC_00300_ALCSRHPTHRUL 
   where 1=1 
    and lngdsc = @lngdsc 
	   and wh_id = @wh_id
	    and alloc_search_path_id = @alloc_search_path_id
		and pck_zone_id = @pck_zone_id
		and pck_mthd_id = @pck_mthd_id
  ] catch (-1403,510) 
  |
  if (@? != 0)
  {
    create allocation search path rule
      where uc_called_from_mload = '1' 
  }
  else 
  {
    change allocation search path rule
      where uc_called_from_mload = '1' 
	  and alloc_search_path_id = @alloc_search_path_id
	  and alloc_search_path_rule_id = @old_alloc_search_path_rule_id
  }
}