[delete from rf_frm_mst
 where rf_frm = '@rf_frm@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)