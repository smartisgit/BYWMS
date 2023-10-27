[delete from usr_arerpk
 where wh_id = '@wh_id@' and 
arecod = '@arecod@' and 
seqnum = '@seqnum@' and 
rpkcls = '@rpkcls@' 
] catch (-1403)