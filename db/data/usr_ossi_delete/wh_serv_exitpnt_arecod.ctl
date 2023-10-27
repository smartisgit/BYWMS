[delete wh_serv_exitpnt_arecod
  where serv_id = '@serv_id@'
    and wh_id = '@wh_id@'
    and exitpnt_typ = '@exitpnt_typ@'
    and exitpnt = '@exitpnt@'
    and srcare = '@srcare@'
    and dstare = '@dstare@'] catch(-1403, 510)