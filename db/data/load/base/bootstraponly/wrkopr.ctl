publish data where table = 'wrkopr' and uc_called_from_mload = '1'
and oprcod = '@oprcod@'
and wh_id_tmpl = '@wh_id_tmpl@'
and baspri = '@baspri@'
and exptim = '@exptim@'
and escinc = '@escinc@'
and esc_shpdte_flg = '@esc_shpdte_flg@'
and esc_shpdte_field = '@esc_shpdte_field@'
and maxescpri = '@maxescpri@'
and begdaycod = '@begdaycod@'
and begtim = '@begtim@'
and enddaycod = '@enddaycod@'
and endtim = '@endtim@'
and use_src_flg = '@use_src_flg@'
and esc_cmd_flg = '@esc_cmd_flg@'
and esc_cmd = '@esc_cmd@'
and rls_cmd = '@rls_cmd@'
and init_sts = '@init_sts@'
and force_ack_loc_flg = '@force_ack_loc_flg@'
|
{
    create record 
    catch (-1,512)
    |
    if ( @? != 0 )
        change record catch (-1403,510)
}

