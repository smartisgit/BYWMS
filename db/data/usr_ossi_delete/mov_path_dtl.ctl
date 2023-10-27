[delete from mov_path_dtl
 where srcare = '@srcare@' and 
dstare = '@dstare@' and 
wh_id = '@wh_id@' and 
lodlvl = '@lodlvl@' and 
hopseq = '@hopseq@' and 
hopare = '@hopare@' 
] catch (-1403)