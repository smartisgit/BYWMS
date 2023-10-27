[delete from les_var_inp
 where var_nam = '@var_nam@' and 
appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
addon_id = '@addon_id@' and 
locale_id = '@locale_id@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)