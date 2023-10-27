[delete from profile_flds
 where appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
prf_nam = '@prf_nam@' and 
var_nam = '@var_nam@' 
] catch (-1403)