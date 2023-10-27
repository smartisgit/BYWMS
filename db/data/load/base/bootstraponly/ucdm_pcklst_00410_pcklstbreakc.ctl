publish data 
where table = 'pcklst_break_on_cri'
and uc_inhibit_version_control = '1'
and pcklst_rule_name = '@pcklst_rule_name@'
and break_on_function = '@break_on_function@'
and break_on_field = '@break_on_field@'
and max_weight = '@max_weight@'
and max_volume = '@max_volume@'
and max_qty = '@max_qty@'
and volume_thr = '@volume_thr@'
and max_add_pick_weight = '@max_add_pick_weight@'
and seqnum = '@seqnum@'
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
    from ucdm_pcklst_00410_pcklstbreakc
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
            where pcklst_break_on_cri_id = nextval('pcklst_break_on_cri_id')
            |
            create record where uc_called_from_mload = '1'
            catch (-1,512)
        }
        else if ( @uc_change_allowed = '1' )
        {
            [select pcklst_break_on_cri_id from pcklst_break_on_cri where pcklst_rule_id = @pcklst_rule_id and seqnum = @seqnum]
            |
            change record where uc_called_from_mload = '1'
        }
    }
}
