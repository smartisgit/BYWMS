     publish data     
 where table_name = 'job_definition'     
 and job_id = '@job_id@'     
 and role_id = '@role_id@'     
 and name = '@name@'     
 and enabled = '@enabled@'     
 and type = '@type@'     
 and command = '@command@'     
 and log_file = '@log_file@'     
 and trace_level = '@trace_level@'     
 and overlap = '@overlap@'     
 and schedule = '@schedule@'     
 and start_delay = '@start_delay@'     
 and timer = '@timer@'     
 and grp_nam = '@grp_nam@'     
 and uc_am_i_archive = ossi__am_i_archive()     
 and uc_am_i_dev = ossi__is_dev_env()     
 |     
 if ( @uc_am_i_archive = 0 )     
 {
    publish data
    where uc_orig_job_id = @job_id
    |     
    /* If we defined a job for WMD1 that means it goes to all warehoses */     
    if ( @uc_am_i_dev != '1' and @job_id like 'UC_W_WMD1_%' )     
    {     
        [     
        select replace(@job_id, 'UC_W_WMD1_', 'UC_W_' || wh_id || '_' ) job_id,     
               wh_id || '-' || @name name,     
               replace(@command,  'WMD1', wh_id ) command,     
               replace(@log_file, 'WMD1', wh_id ) log_file     
        from wh     
        where wh_id != 'WMD1'     
        order by 1     
        ] catch(-1403,510)  
    }     
    |
    /* if it is a job id type that we replicate to all warehouses - we will creare it only if it is enabled in rollout */
    if ( @uc_orig_job_id like 'UC_W_WMD1_%' and @enabled = '0' )
    {
        /* If rollout had job called UC_W_WMD1 (implying replicate) but was disabled - simply ignore the record */
        noop
    }
    else
    {     
        [     
        select grp_nam     
        from job_definition     
        where JOB_ID = @JOB_ID     
        ]     
        catch (-1403,510)     
        |     
        if ( @? != 0 )     
            create record     
            where uc_called_from_mload = '1'     
        else if ( @grp_nam != 'GK' and @grp_nam != 'L' )     
        {     
            change record     
            where uc_called_from_mload = '1'     
        }     
    }     
}