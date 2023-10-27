[MERGE INTO les_mnu_grp l 
      USING (SELECT '@mnu_grp@' mnu_grp, '@par_grp@' par_grp, @mnu_seq@ mnu_seq, '@btn_img_id@' btn_img_id, '@grp_nam@' grp_nam
                    FROM dual) input 
         ON (l.mnu_grp = input.mnu_grp) 
 WHEN MATCHED THEN 
     UPDATE SET par_grp = input.par_grp, 
                mnu_seq = input.mnu_seq, 
                btn_img_id = input.btn_img_id, 
                grp_nam = input.grp_nam
 WHEN NOT MATCHED THEN
     INSERT (mnu_grp, par_grp, mnu_seq, btn_img_id, grp_nam) 
     VALUES (input.mnu_grp, input.par_grp, input.mnu_seq, input.btn_img_id, input.grp_nam)]
