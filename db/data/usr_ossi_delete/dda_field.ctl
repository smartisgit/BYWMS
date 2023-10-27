[delete from dda_field
 where dda_id = '@dda_id@' and 
cust_lvl = '@cust_lvl@' and 
dda_fld_typ = '@dda_fld_typ@' and 
var_nam = '@var_nam@' 
]catch (-1403)
