[delete from grid_dsp_rule
 where appl_id = '@appl_id@' and 
frm_id = '@frm_id@' and 
lvl_id = '@lvl_id@' and 
grid_nam = '@grid_nam@' and 
usr_id = '@usr_id@' and 
grid_fld_nam = '@grid_fld_nam@' and 
srt_seq = '@srt_seq@' 
] catch (-1403)