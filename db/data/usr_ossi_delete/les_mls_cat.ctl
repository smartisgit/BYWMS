[delete from les_mls_cat
 where mls_id = '@mls_id@' and 
locale_id = '@locale_id@' and 
prod_id = '@prod_id@' and 
appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
vartn = '@vartn@' and 
srt_seq = '@srt_seq@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)