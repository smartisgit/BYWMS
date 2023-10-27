[delete from serv_action
 where serv_id = '@serv_id@' and 
serv_action_typ = '@serv_action_typ@' and 
serv_action_cod = '@serv_action_cod@' and 
seqnum = '@seqnum@' 
] catch (-1403)