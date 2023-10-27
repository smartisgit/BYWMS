[MERGE INTO les_opt_ath l
      USING (SELECT '@opt_nam@' opt_nam, '@ath_typ@' ath_typ, '@ath_id@' ath_id, @pmsn_mask@ pmsn_mask, '@grp_nam@' grp_nam
                    FROM dual) input
         ON (l.opt_nam = input.opt_nam
             AND l.ath_typ = input.ath_typ
             AND l.ath_id = input.ath_id)
 WHEN MATCHED THEN
     UPDATE SET pmsn_mask = input.pmsn_mask,
                grp_nam = input.grp_nam
 WHEN NOT MATCHED THEN
     INSERT (opt_nam, ath_typ, ath_id, pmsn_mask, grp_nam)
     VALUES (input.opt_nam, input.ath_typ, input.ath_id, input.pmsn_mask, input.grp_nam)]
