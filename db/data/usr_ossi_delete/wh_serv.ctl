[delete from wh_serv
 where serv_id = '@serv_id@' and 
wh_id = '@wh_id@' 
] catch (-1403)