[delete from grd_view_def
 where lvl_id = '@lvl_id@' and 
appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
addon_id = '@addon_id@' and 
grd_var_nam = '@grd_var_nam@' and 
view_nam = '@view_nam@' and 
usr_id = '@usr_id@' 
] catch (-1403)