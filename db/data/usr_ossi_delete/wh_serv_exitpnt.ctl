[delete from wh_serv_exitpnt
 where serv_id = '@serv_id@' and 
wh_id = '@wh_id@' and 
exitpnt_typ = '@exitpnt_typ@' and 
exitpnt = '@exitpnt@' 
] catch (-1403)