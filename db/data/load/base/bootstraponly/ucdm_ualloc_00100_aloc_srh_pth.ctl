publish data 
where uc_inhibit_version_control = '1'
and wh_id = '@wh_id@'
and srtseq = '@srtseq@'
and search_path_typ = '@search_path_typ@'
and ins_dt = '@ins_dt@'
and last_upd_dt = '@last_upd_dt@'
and ins_user_id = '@ins_user_id@'
and last_upd_user_id = '@last_upd_user_id@'
and lngdsc = '@lngdsc@'
|
{
  [select alloc_search_path_id 
   from UCDM_UALLOC_00100_ALOC_SRH_PTH 
  where 1=1 
    and lngdsc = @lngdsc 
    and wh_id = @wh_id 
  ] catch (-1403,510) 
  |
  if (@? != 0)
  {
    create allocation search path 
      where uc_called_from_mload = '1' 
  }
  else 
  {
    change allocation search path
      where uc_called_from_mload = '1' 
  }
}