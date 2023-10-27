publish data
where table_name      = 'usr_rule_engine_cond_expr'
and uc_rule_grp_id    = '@uc_rule_grp_id@'
and uc_rule_subgrp_id = '@uc_rule_subgrp_id@'
and uc_rule_id        = '@uc_rule_id@'
and seqnum            = '@seqnum@'
and srtseq            = '@srtseq@'
and ena_flg           = '@ena_flg@'
and uc_condition_expr = '@uc_condition_expr@'
and uc_execute_cmd    = '@uc_execute_cmd@'
and uc_rule_catg_cd   = '@uc_rule_catg_cd@'
and uc_rule_comment   = '@uc_rule_comment@'
|
{
    [
    select uc_cust_flg
    from @table_name:raw
    where uc_rule_grp_id = @uc_rule_grp_id
    and uc_rule_subgrp_id = @uc_rule_subgrp_id
    and uc_rule_id = @uc_rule_id
    and seqnum = @seqnum
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