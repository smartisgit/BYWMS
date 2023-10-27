[
delete from rule_parm
 where rule_nam = '@rule_nam@' and 
parm_id = '@parm_id@' 
] catch (-1403)