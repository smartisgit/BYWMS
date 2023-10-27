publish data 
where table = 'pcklst_grp_cri'
and uc_inhibit_version_control = '1'
and pcklst_rule_name = '@pcklst_rule_name@'
and seqnum = '@seqnum@'
and table_nam = '@table_nam@'
and field_name = '@field_name@'
and uc_change_allowed = '0'
|
[
select wh_id
from wh
]
|
{
    [
    select count(*) cnt 
    from ucdm_pcklst_00420_pcklstgrpcri
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
        if ( @? = 0 and @cnt = 0 ) 
        {
            publish data 
            where pcklst_grp_cri_id = nextval('pcklst_grp_cri_id')
            |
            create record where uc_called_from_mload = '1'
            catch (-1,512)

        }
        else if ( @? = 0 )
        {
            [select pcklst_grp_cri_id from pcklst_grp_cri where pcklst_rule_id = @pcklst_rule_id and seqnum = @seqnum]
            |            
            change record where uc_called_from_mload = '1'
        }
    }
}
