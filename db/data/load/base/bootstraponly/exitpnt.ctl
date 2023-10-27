[ select count(*) row_count 
    from exitpnt 
   where exitpnt_typ = '@exitpnt_typ@' 
     and exitpnt = '@exitpnt@']
    | 
    if (@row_count > 0)     
    { 
        [ update exitpnt
           set exitpnt_typ = '@exitpnt_typ@',
               exitpnt     = '@exitpnt@',
               tblnme      = '@tblnme@'
         where exitpnt_typ = '@exitpnt_typ@'
           and exitpnt     = '@exitpnt@' ]
    }
    else
    {
        [ insert into exitpnt 
              (exitpnt_typ, 
               exitpnt, 
               tblnme) 
          values 
              ('@exitpnt_typ@',
               '@exitpnt@',
               '@tblnme@') ]
    }  
