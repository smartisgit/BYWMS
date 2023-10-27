publish data
where table_name      = 'prsmst'
and prtadr            = '@prtadr@'
and wh_id             = '@wh_id@'
and tcpadr            = '@tcpadr@'
and rerprt            = '@rerprt@'
and prtsts            = '@prtsts@'
and prtnam            = '@prtnam@'
and prttyp            = '@prttyp@'
and svqflg            = '@svqflg@'
and prtque            = '@prtque@'
and uc_change_allowed = nvl ( '@uc_change_allowed@', '0' )
|
{
    [
    select 1
    from @table_name:raw
    where prtadr = @prtadr
    ]
    catch (-1403,510)
    |
    if ( @? != 0 )
        create record where uc_called_from_mload = '1'
    else if ( @uc_change_allowed = '1' )
        change record where uc_called_from_mload = '1'
}