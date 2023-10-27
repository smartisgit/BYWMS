[delete from les_cmd
 where les_cmd_id = '@les_cmd_id@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)