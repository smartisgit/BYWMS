[delete from dscmst
 where colnam = '@colnam@' and 
colval = '@colval@' and 
locale_id = '@locale_id@' 
] catch (-1403)