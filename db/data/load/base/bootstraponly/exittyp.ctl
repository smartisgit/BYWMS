[ select count(*) row_count 
    from exittyp 
   where exitpnt_typ = '@exitpnt_typ@']
   |  
    if (@row_count = 0) 
    { 
        [ insert into exittyp 
              (exitpnt_typ) 
            values 
              ('@exitpnt_typ@') ] 
    } 
