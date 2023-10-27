[delete from wf_flw
 where appl_id = '@appl_id@' and 
cust_lvl = '@cust_lvl@' and 
frm_id = '@frm_id@' 
] catch (-1403)