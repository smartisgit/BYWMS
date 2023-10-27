[MERGE INTO les_mnu_opt l
      USING (SELECT '@opt_nam@' opt_nam, '@opt_typ@' opt_typ, @pmsn_mask@ pmsn_mask, to_number('@ena_flg@') ena_flg, '@exec_nam@' exec_nam, 
                    '@exec_parm@' exec_parm, '@btn_img_id@' btn_img_id, '@ath_grp_nam@' ath_grp_nam, '@addon_id@' addon_id, 
                    '@grp_nam@' grp_nam
                    FROM dual) input 
         ON (l.opt_nam = input.opt_nam)
 WHEN MATCHED THEN 
     UPDATE SET opt_typ = input.opt_typ,
                pmsn_mask = input.pmsn_mask,
                ena_flg = input.ena_flg,
                exec_nam = input.exec_nam,
                exec_parm = input.exec_parm,
                btn_img_id = input.btn_img_id,
                ath_grp_nam = input.ath_grp_nam,
                addon_id = input.addon_id,
                grp_nam = input.grp_nam
 WHEN NOT MATCHED THEN
     INSERT (opt_nam, opt_typ, pmsn_mask, ena_flg, exec_nam, exec_parm, btn_img_id, ath_grp_nam, addon_id, grp_nam) 
     VALUES (input.opt_nam, input.opt_typ, input.pmsn_mask, input.ena_flg, input.exec_nam, input.exec_parm, input.btn_img_id, 
             input.ath_grp_nam, input.addon_id, input.grp_nam)]
