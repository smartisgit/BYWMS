publish data
where table_name      = 'usr_rule_engine_help_ctxt'
and uc_rule_engine_table_name = '@uc_rule_engine_table_name@'
and uc_rule_grp_id    = '@uc_rule_grp_id@'
and uc_rule_subgrp_id = nvl('@uc_rule_subgrp_id@','----')
and uc_rule_id        = nvl('@uc_rule_id@','----')
and seqnum            = '@seqnum@'
and srtseq            = nvl('@srtseq@', '@seqnum@' )
and uc_fetch_ctxt_typ = '@uc_fetch_ctxt_typ@'
and uc_fetch_ctxt_expr= '@uc_fetch_ctxt_expr@'
and uc_ctxt_var       = '@uc_ctxt_var@'
and uc_ctxt_var_descr = '@uc_ctxt_var_descr@'
|
{
    [
    select 1
    from @table_name:raw
    where uc_rule_grp_id = @uc_rule_grp_id
    and uc_rule_subgrp_id = @uc_rule_subgrp_id
    and uc_rule_id = @uc_rule_id
    and uc_rule_engine_table_name = @uc_rule_engine_table_name
    and seqnum = @seqnum
    ]
    catch (-1403,510)
    |
    if ( @? = 0 )
    {
        change record where uc_called_from_mload = '1'
    }
    else
        create record where uc_called_from_mload = '1'
}