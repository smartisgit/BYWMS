[delete from pcklst_rule_grp_dtl
 where 1=1
and pcklst_rule_grp_id = '@pcklst_rule_grp_id@'
and pcklst_rule_id = '@pcklst_rule_id@'] catch(-1403,510)
