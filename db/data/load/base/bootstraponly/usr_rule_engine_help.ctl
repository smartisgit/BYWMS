publish data
where table_name      = 'usr_rule_engine_help'
and uc_rule_engine_table_name = '@uc_rule_engine_table_name@'
and uc_rule_grp_id    = '@uc_rule_grp_id@'
and uc_rule_subgrp_id = nvl('@uc_rule_subgrp_id@','----')
and uc_rule_id        = nvl('@uc_rule_id@','----')
and uc_rule_grp_catg = '@uc_rule_grp_catg@'
and uc_rule_grp_id_srtseq = '@uc_rule_grp_id_srtseq@'
and uc_short_help = '@uc_short_help@'
and uc_long_help = '@uc_long_help@'
|
{
    if ( @uc_short_help is null ) hide stack variable where name = 'uc_short_help'
    |
    if ( @uc_long_help is null ) hide stack variable where name = 'uc_long_help'
    |
    if ( @uc_rule_grp_catg is null ) hide stack variable where name = 'uc_rule_grp_catg'
    |
    if ( @uc_rule_grp_id_srtseq is null ) hide stack variable where name = 'uc_rule_grp_id_srtseq'
    |
    [
    select 1
    from @table_name:raw
    where uc_rule_grp_id = @uc_rule_grp_id
    and uc_rule_subgrp_id = @uc_rule_subgrp_id
    and uc_rule_id = @uc_rule_id
    and uc_rule_engine_table_name = @uc_rule_engine_table_name
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