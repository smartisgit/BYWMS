[delete from dda_mst
 where dda_id = '@dda_id@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)