[delete from wf_appl
 where appl_id = '@appl_id@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)