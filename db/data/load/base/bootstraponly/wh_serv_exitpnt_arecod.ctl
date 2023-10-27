publish data 
where serv_id = '@serv_id@' 
and wh_id = '@wh_id@' 
and exitpnt_typ = '@exitpnt_typ@' 
and exitpnt = '@exitpnt@' 
and srcare = '@srcare@'
and dstare = '@dstare@'
and table = 'wh_serv_exitpnt_arecod'
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
   select count(*) cnt_srcare
   from aremst
   where wh_id = @wh_id
   and arecod = @srcare
   ]
   |
   [
   select count(*) cnt_dstare
   from aremst
   where wh_id = @wh_id
   and arecod = @dstare
   ]
   |
   publish data
   where srcare_valid = iif ( @srcare = 'XXXX' or @cnt_srcare > 0, 1, 0 )
   and dstare_valid = iif ( @dstare = 'XXXX' or @cnt_dstare > 0, 1, 0 )
   |
   if ( @srcare_valid = 1 and @dstare_valid = 1 )
   {
      [
      select count(*) cnt 
      from wh_serv_exitpnt_arecod 
      where serv_id = @serv_id
      and wh_id = @wh_id
      and exitpnt_typ = @exitpnt_typ
      and exitpnt = @exitpnt
      and srcare = @srcare
      and dstare = @dstare
      ]
      |
      if ( @cnt = 0 ) 
         create record
   }
}
