[delete from les_lkp
 where lkp_id = '@lkp_id@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)