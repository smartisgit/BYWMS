[delete from chart_prop
 where chart_id = '@chart_id@' and 
cust_lvl = '@cust_lvl@' and 
var_nam = '@var_nam@' 
] catch (-1403)