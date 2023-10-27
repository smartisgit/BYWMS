{
    list warehouses
     where wh_id = '@wh_id@' catch(@?)
    |
    publish data
     where error = @?
       and wh_id = '@wh_id@'
}
|
[select case when @error = 0 then @wh_id
             when '@wh_id@' = '----' then '@wh_id@'
             else 'n/a'
        end as wh_id
   from dual]
|
if (@wh_id != 'n/a')
{
    [select count(*) row_count
       from wh_serv_exitpnt
      where serv_id = '@serv_id@'
        and wh_id = '@wh_id@'
        and exitpnt_typ = '@exitpnt_typ@'
        and exitpnt = '@exitpnt@']
    |
    if (@row_count > 0)
    {
        [update wh_serv_exitpnt
            set serv_id = '@serv_id@',
                wh_id = '@wh_id@',
                exitpnt_typ = '@exitpnt_typ@',
                exitpnt = '@exitpnt@',
                moddte = to_date('@moddte@', 'YYYYMMDDHH24MISS'),
                mod_usr_id = '@mod_usr_id@'
          where serv_id = '@serv_id@'
            and wh_id = '@wh_id@'
            and exitpnt_typ = '@exitpnt_typ@'
            and exitpnt = '@exitpnt@']
    }
    else
    {
        [insert
           into wh_serv_exitpnt(serv_id, wh_id, exitpnt_typ, exitpnt, moddte, mod_usr_id)
         VALUES ('@serv_id@', '@wh_id@', '@exitpnt_typ@', '@exitpnt@', to_date('@moddte@', 'YYYYMMDDHH24MISS'), '@mod_usr_id@')]
    }
};