[delete from les_var_lkp
 where var_nam = '@var_nam@' and 
appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
addon_id = '@addon_id@' and 
cust_lvl = '@cust_lvl@' and
lkp_id = '@lkp_id@'
] catch (-1403)