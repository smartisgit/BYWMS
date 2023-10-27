[delete from dda_fltr_grp
 where fltr_grp = '@fltr_grp@' and 
cust_lvl = '@cust_lvl@' 
] catch (-1403)