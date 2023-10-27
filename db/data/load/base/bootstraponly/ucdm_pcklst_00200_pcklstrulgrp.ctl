publish data 
where table = 'pcklst_rule_grp'
and uc_inhibit_version_control = '1'
and pcklst_rule_grp_name = '@pcklst_rule_grp_name@'
and wh_id = '@wh_id@'
and client_id = '@client_id@'
and ena_flg = '@ena_flg@'
and lngdsc = '@lngdsc@'
and uc_change_allowed = '1'
|
{
    if ( @wh_id = 'WMD1' )
        [
        select distinct wh.wh_id,
               nvl(client_wh.client_id, @client_id) client_id
          from wh
          left
          join client_wh
            on wh.wh_id = client_wh.wh_id
         order by 1
        ]
    |
    [
    select count(*) cnt,
           max(pcklst_rule_grp_id) pcklst_rule_grp_id
    from ucdm_pcklst_00200_pcklstrulgrp 
    where 1=1 
    and pcklst_rule_grp_name = @pcklst_rule_grp_name
    and wh_id = @wh_id
    ]
    |
    if ( @cnt = 0 ) 
        create pick list rule group where uc_called_from_mload = '1'
    else if ( @uc_change_allowed = '1' )
        change pick list rule group where uc_called_from_mload = '1'
}
