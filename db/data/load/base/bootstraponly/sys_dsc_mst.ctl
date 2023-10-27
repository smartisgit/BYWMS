[select count(*) row_count 
  from sys_dsc_mst
 where colnam = '@colnam@' and 
colval = '@colval@' and 
locale_id = '@locale_id@' and 
cust_lvl = '@cust_lvl@' 
]
|
if (@row_count > 0)
{
[update sys_dsc_mst set
mls_text = '@mls_text@',
short_dsc = '@short_dsc@',
grp_nam = '@grp_nam@'
where colnam = '@colnam@' and 
colval = '@colval@' and 
locale_id = '@locale_id@' and 
cust_lvl = '@cust_lvl@' 
]
}
else
{
[insert into sys_dsc_mst
(colnam,colval,locale_id,cust_lvl,mls_text,short_dsc,grp_nam)
VALUES
('@colnam@','@colval@','@locale_id@','@cust_lvl@','@mls_text@','@short_dsc@','@grp_nam@')
]
}