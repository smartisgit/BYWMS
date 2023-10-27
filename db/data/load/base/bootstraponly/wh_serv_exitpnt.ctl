publish data 
where serv_id = '@serv_id@' 
and wh_id = '@wh_id@' 
and exitpnt_typ = '@exitpnt_typ@' 
and exitpnt = '@exitpnt@' 
and table = 'wh_serv_exitpnt'
and uc_called_from_mload = '1' 
and uc_change_allowed = '0'
|
[
select wh_id
from wh
]
|
{
   [
   select count(*) row_count 
   from wh_serv_exitpnt 
   where serv_id = @serv_id
   and wh_id = @wh_id
   and exitpnt_typ = @exitpnt_typ
   and exitpnt = @exitpnt
   ]
   |
   if ( @row_count = 0 ) 
      create record
}
