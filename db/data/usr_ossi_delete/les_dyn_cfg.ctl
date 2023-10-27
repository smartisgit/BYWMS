[delete from les_dyn_cfg
 where dyn_cfg_id = '@dyn_cfg_id@' and 
appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
addon_id = '@addon_id@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)