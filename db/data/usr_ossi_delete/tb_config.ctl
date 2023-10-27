[delete from tb_config
 where appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
btn_key = '@btn_key@' and 
par_btn_key = '@par_btn_key@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)