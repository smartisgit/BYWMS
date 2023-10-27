publish data 
where table = 'pcklst_select_cri'
and uc_inhibit_version_control = '1'
and pcklst_rule_name = '@pcklst_rule_name@'
and seqnum = '@seqnum@'
and log_opr = '@log_opr@'
and table_nam = '@table_nam@'
and field_name = '@field_name@'
and operator = '@operator@'
and value = '@value@'
and uc_change_allowed = '0'
|
[
select wh_id
from wh
order by 1
]
|
{
    [
    select count(*) cnt 
    from ucdm_pcklst_00400_pcklstsctcri 
    where 1=1 
    and pcklst_rule_name = @pcklst_rule_name
    and seqnum = @seqnum
    and wh_id = @wh_id
    ]
    |
    {
        [select pcklst_rule_id from pcklst_rule where pcklst_rule_name = @pcklst_rule_name and wh_id = @wh_id]
        catch (-1403,510)
        |
        if ( @cnt = 0 and @? = 0) 
        {
            publish data 
            where pcklst_select_cri_id = nextval('pcklst_select_cri_id' )
            |
            create record where uc_called_from_mload = '1'
            catch (-1,512)
        }
        else if ( @uc_change_allowed = '1' )
        {
            [select pcklst_select_cri_id from pcklst_select_cri where pcklst_rule_id = @pcklst_rule_id and seqnum = @seqnum]
            |
            change record where uc_called_from_mload = '1'
        }
    }
}
