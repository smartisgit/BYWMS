publish data 
where table = 'pcklst_rule_grp_dtl'
and uc_inhibit_version_control = '1'
and pcklst_rule_grp_name = '@pcklst_rule_grp_name@'
and pcklst_rule_name = '@pcklst_rule_name@'
and seqnum = '@seqnum@'
and wh_id = '@wh_id@'
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
    select count(*) cnt 
    from ucdm_pcklst_00300_pcklstrulgrd 
    where 1=1 
    and pcklst_rule_grp_name = @pcklst_rule_grp_name
    and pcklst_rule_name = @pcklst_rule_name
    and wh_id = @wh_id
    ]
    |
    if ( @cnt = 0 ) 
    {
        [select pcklst_rule_id from pcklst_rule where pcklst_rule_name = @pcklst_rule_name and wh_id = @wh_id]
        catch (-1403,10)
        |
        if ( @? =0 )
        {
            [select pcklst_rule_grp_id from pcklst_rule_grp where pcklst_rule_grp_name = @pcklst_rule_grp_name and wh_id = @wh_id]
            catch (-1403,510)
            |
            if ( @? = 0 )
            {
                assign pick list rule to rule group where uc_called_from_mload = '1'
            }
        }
    }
}
