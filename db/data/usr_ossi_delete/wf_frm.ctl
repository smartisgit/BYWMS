[delete from wf_frm
 where frm_id = '@frm_id@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)