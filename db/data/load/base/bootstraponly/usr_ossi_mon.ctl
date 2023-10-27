publish data
where table_name           = 'usr_ossi_mon'
and uc_monitor_id          = '@uc_monitor_id@'
and uc_monitor_descr       = '@uc_monitor_descr@'
and ena_flg                = '@ena_flg@'
and uc_check_cmd           = '@uc_check_cmd@'
and uc_fix_cmd             = '@uc_fix_cmd@'
and uc_mon_srtseq          = '@uc_mon_srtseq@'
and uc_log_mon_dlytrn_flg  = '@uc_log_mon_dlytrn_flg@'
and uc_time_since_last_run = '@uc_time_since_last_run@'
and uc_raise_ems_alert_on_fail_flg = '@uc_raise_ems_alert_on_fail_flg@'
|
{
    [
    select uc_cust_flg
    from @table_name:raw
    where uc_monitor_id = @uc_monitor_id
    ]
    catch (-1403,510)
    |
    if ( @? = 0 )
    {
        if (@uc_cust_flg != 1)
            change record where uc_called_from_mload = '1'
    }
    else
        create record where uc_called_from_mload = '1'
}