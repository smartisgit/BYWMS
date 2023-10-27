[delete from pcklst_rule_grp
 where 1=1
and pcklst_rule_grp_id = '@pcklst_rule_grp_id@'] catch(-1403,510)
