[delete from reacod_reagrp
 where reacod = '@reacod@' and 
reagrp = '@reagrp@' and 
client_id = '@client_id@' 
] catch (-1403)