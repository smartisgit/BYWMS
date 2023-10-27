[delete from profile_mst
 where appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
prf_nam = '@prf_nam@' 
] catch (-1403)