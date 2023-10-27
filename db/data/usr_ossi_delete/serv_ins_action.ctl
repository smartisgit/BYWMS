[delete from serv_ins_action
 where serv_ins_id = '@serv_ins_id@' and 
serv_action_typ = '@serv_action_typ@' and 
serv_action_cod = '@serv_action_cod@' and 
seqnum = '@seqnum@' 
] catch (-1403)