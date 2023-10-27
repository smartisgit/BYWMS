[delete from are_pck_flg
 where srcare = '@srcare@' and 
lodlvl = '@lodlvl@' and 
wrktyp = '@wrktyp@' and 
wh_id = '@wh_id@' 
] catch (-1403)