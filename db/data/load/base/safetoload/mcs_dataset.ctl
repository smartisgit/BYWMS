[ select count(*) row_count 
    from mcs_dataset 
   where ds_name = '@ds_name@' 
     and ds_desc = '@ds_desc@' 
     and ds_dir = '@ds_dir@' 
     and ds_seq = @ds_seq@ 
] 

| 
   if (@row_count > 0) 
   {
       [ update mcs_dataset 
           set
             ds_name = '@ds_name@',          
	     ds_desc = '@ds_desc@',          
	     ds_dir = '@ds_dir@',          
	     ds_seq = @ds_seq@
	   where ds_name = '@ds_name@' 
	     and ds_desc = '@ds_desc@' 
	     and ds_dir = '@ds_dir@' 
	     and ds_seq = @ds_seq@ 
       ]
   }
   else 
   {
       [ insert into mcs_dataset
               (ds_name, ds_desc, ds_dir, ds_seq)
            VALUES
               ('@ds_name@', '@ds_desc@', '@ds_dir@', @ds_seq@) 
       ] 
   }
