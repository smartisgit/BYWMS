[delete from dda_child
 where dda_id = '@dda_id@' and 
dda_typ = '@dda_typ@' and 
dda_child_id = '@dda_child_id@' and 
dda_child_typ = '@dda_child_typ@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)