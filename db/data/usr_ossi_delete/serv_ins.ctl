[
delete serv_ins
where serv_id = '@serv_id@'
and serv_ins_id = '@serv_ins_id@'
]
catch(-1403,510)
