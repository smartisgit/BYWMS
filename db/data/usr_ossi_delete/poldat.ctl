[delete from poldat
where polcod = '@polcod@'
and polvar = '@polvar@'
and polval = '@polval@'
and wh_id_tmpl = '@wh_id_tmpl@'
and srtseq = '@srtseq@'
]
catch (-1403,510)