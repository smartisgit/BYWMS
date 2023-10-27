[delete from are_invmix_rule
 where arecod = '@arecod@' and 
wh_id = '@wh_id@' and 
tblnme = '@tblnme@' and 
column_name = '@column_name@' 
] catch (-1403)