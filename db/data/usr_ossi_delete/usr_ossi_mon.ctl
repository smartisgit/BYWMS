[
delete from usr_ossi_mon
where uc_monitor_id = '@uc_monitor_id@' 
] 
catch (-1403,510)