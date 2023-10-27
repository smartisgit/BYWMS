[delete from les_lkp_fld
 where lkp_id = '@lkp_id@' and 
cust_lvl = '@cust_lvl@' and 
fld_nam = '@fld_nam@' 
] catch (-1403)