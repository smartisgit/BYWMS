[
delete from usr_rule_engine_cond_expr
where uc_rule_grp_id = '@uc_rule_grp_id@'
and uc_rule_subgrp_id = '@uc_rule_subgrp_id@'
and uc_rule_id = '@uc_rule_id@'
and seqnum = '@seqnum@'
] 
catch (-1403,510)