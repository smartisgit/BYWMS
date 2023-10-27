[MERGE INTO les_mnu_itm l
      USING (SELECT '@mnu_grp@' mnu_grp, '@mnu_itm@' mnu_itm, @mnu_seq@ mnu_seq, '@opt_nam@' opt_nam, '@grp_nam@' grp_nam
                    FROM dual) input
         ON (l.mnu_grp = input.mnu_grp
             AND l.mnu_itm = input.mnu_itm)
 WHEN MATCHED THEN 
     UPDATE SET mnu_seq = input.mnu_seq,
                opt_nam = input.opt_nam,
                grp_nam = input.grp_nam
 WHEN NOT MATCHED THEN
     INSERT (mnu_grp, mnu_itm, mnu_seq, opt_nam, grp_nam)
     VALUES (input.mnu_grp, input.mnu_itm, input.mnu_seq, input.opt_nam, input.grp_nam)]
