[delete from sys_dsc_mst
 where colnam = '@colnam@' and 
colval = '@colval@' and 
locale_id = '@locale_id@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)