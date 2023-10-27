publish data 
where uc_inhibit_version_control = '1'
and wh_id = '@wh_id@'
and srtseq = '@srtseq@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and lngdsc = '@lngdsc@'
|
{
  [select sto_config_id 
   from UCDM_SCONFIG_00100_STO_CONFIG 
  where 1=1 
    and lngdsc = @lngdsc 
    and wh_id = @wh_id 
  ] catch (-1403,510) 
  |
  if (@? != 0)
  {
    create storage configuration 
      where uc_called_from_mload = '1' 
  }
  else 
  {
    change storage configuration
      where uc_called_from_mload = '1' 
  }
}