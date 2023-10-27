publish data 
where uc_inhibit_version_control = '1'
and bldg_id = '@bldg_id@'
and srtseq = '@srtseq@'
and strategy = '@strategy@'
and min_lvl = '@min_lvl@'
and max_lvl = '@max_lvl@'
and lvl_by_item_flg = '@lvl_by_item_flg@'
and max_lod_per_aisle = '@max_lod_per_aisle@'
and lod_by_item_flg = '@lod_by_item_flg@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and sto_zone_cod = '@sto_zone_cod@'
and lngdsc = '@lngdsc@'
and wh_id = '@wh_id@'
|
{
    [select sto_config_id 
     from UCDM_SCONFIG_00100_STO_CONFIG 
     where 1=1 
     and lngdsc = @lngdsc 
     and wh_id = @wh_id 
     ] catch (-1403,510)
	 |
  [select sto_zone_id 
   from sto_zone 
   where sto_zone_cod = @sto_zone_cod 
   and wh_id = @wh_id
  ] catch(-1403, 510)
  |
  [select distinct sto_config_id old_sto_config_id,
          sto_config_rule_id old_sto_config_rule_id
   from UCDM_SCONFIG_00300_STO_CON_RUL
   where 1=1 
    and lngdsc = @lngdsc 
	and wh_id = @wh_id
	and strategy = @strategy
	and sto_config_id = @sto_config_id
  ] catch (-1403,510) 
  |
  if (@? != 0)
  {
    create storage configuration rule
      where uc_called_from_mload = '1' 
  }
  else 
  {
    change storage configuration rule
      where uc_called_from_mload = '1' 
	  and sto_config_id = @old_sto_config_id
	  and sto_config_rule_id = @old_sto_config_rule_id
  }
}