#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>
/*#include <dbcalls.h>*/

/*#include <varerr.h>*/
#include <usrossierr.h>


LIBEXPORT 
RETURN_STRUCT* ossiTransposeResult
               (  
                  mocaDataRes **i_res,
                  char        *i_colnam_col,
                  char        *i_attr_expr

               )
{
   long             stat = eOK;
   RETURN_STRUCT    *rp = NULL;

   mocaDataRow      *row = NULL;
   mocaDataRes      *res = NULL;

   char             *publish_data_cmd = NULL;
   char             *name_of_col = NULL;
   char             missing [100];

   /* Start */

   if (! i_res)
   {
      stat = eINVALID_ARGS;
      strcpy ( missing, "resultset" );
      goto end_of_function;
   }

   if (! i_colnam_col )
   {
      stat = eINVALID_ARGS;
      strcpy ( missing, "colnam_col" );
      goto end_of_function;
   }

   if (! i_attr_expr )
   {
      stat = eINVALID_ARGS;
      strcpy ( missing, "attr_expr" );
      goto end_of_function;
   }

   res = *i_res;
   if (sqlGetNumRows(res) ==  0) 
      return  srvResults(eOK,NULL);

   for ( row = sqlGetRow(res); row; row = sqlGetNextRow(row) )
   {
      misDynStrcpy ( &name_of_col, sqlGetString ( res, row, i_colnam_col ) );
      misDynStrcat ( &name_of_col, " = " );
      misDynStrcat ( &name_of_col, sqlGetString ( res, row, i_attr_expr ) );

      if ( publish_data_cmd == NULL )
      {
         misDynStrcpy ( &publish_data_cmd, "publish data where " );
         misDynStrcat ( &publish_data_cmd, name_of_col );
      }
      else
      {
         misDynStrcat ( &publish_data_cmd, "\nand" );
         misDynStrcat ( &publish_data_cmd, name_of_col );
      }
   }

   misTrc ( T_FLOW, "--Statement [%s]", publish_data_cmd );
   srvInitiateInline ( publish_data_cmd, &rp );

end_of_function:
   if ( publish_data_cmd )
      free ( publish_data_cmd );

   if ( name_of_col )
      free ( name_of_col );

return srvErrorResults(eINVALID_ARGS, "Missing level argument", NULL);
   return rp;
}

