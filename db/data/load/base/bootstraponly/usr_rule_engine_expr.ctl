publish data
where table_name = 'usr_rule_engine_expr'
and uc_rule_grp_id = '@uc_rule_grp_id@'
and uc_rule_subgrp_id = '@uc_rule_subgrp_id@'
and uc_rule_value = '@uc_rule_value@'
and seqnum = '@seqnum@'
and srtseq = '@srtseq@'
and ena_flg = '@ena_flg@'
and uc_rule_expr = '@uc_rule_expr@'
and uc_rule_parm_01 = '@uc_rule_parm_01@'
and uc_rule_parm_02 = '@uc_rule_parm_02@'
and uc_rule_comment = '@uc_rule_comment@'
and uc_rule_catg_cd = '@uc_rule_catg_cd@'
|
{
    [
    select uc_cust_flg
    from @table_name:raw
    where uc_rule_grp_id = @uc_rule_grp_id
    and uc_rule_subgrp_id = @uc_rule_subgrp_id
    and seqnum = @seqnum
    ]
    catch (-1403,510)
    |
    if ( @? = 0 )
    {
        if ( @uc_cust_flg != 1 )
            change record where uc_called_from_mload = '1'
    }
    else
        create record where uc_called_from_mload = '1'
}
