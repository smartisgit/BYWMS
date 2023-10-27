[delete from dda_action
 where dda_id = '@dda_id@' and 
action = '@action@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)