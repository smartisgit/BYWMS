#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>

/*#include <varerr.h> */
#include <usrossierr.h>

LIBEXPORT 
RETURN_STRUCT* usrOssiTransposeResult
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

printf ( "Entered\n" );
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

printf ( "loop - %s - %s - %p - %p\n", i_colnam_col, i_attr_expr, res, row );
   for ( row = sqlGetRow(res); row; row = sqlGetNextRow(row) )
   {
      char* cc = NULL;
      char* vv = NULL;

printf ( "in loop -%p - %p\n",  res, row );

      cc = sqlGetString ( res, row, i_colnam_col );
      vv = sqlGetString ( res, row, i_attr_expr );

printf ( "cc = %p, vv = %p\n", cc, vv );
printf ( "\n" );

printf ( "cc = %s\n", cc );
printf ( "vv = %s\n", vv );

      if ( cc != NULL ) 
      {
printf ( "-building1\n" );
         misDynStrcpy ( &name_of_col, cc );

printf ( "-building2\n" );
         misDynStrcat ( &name_of_col, " = '" );

printf ( "-building3\n" );
         misDynStrcat ( &name_of_col, vv != NULL ? vv : "" );

printf ( "-building4\n" );
         misDynStrcat ( &name_of_col, "'" );

printf ( "if\n" );
         if ( publish_data_cmd == NULL )
         {
            misDynStrcpy ( &publish_data_cmd, "publish data where " );
            misDynStrcat ( &publish_data_cmd, name_of_col );
         }
         else
         {
            misDynStrcat ( &publish_data_cmd, "\nand " );
            misDynStrcat ( &publish_data_cmd, name_of_col );
         }

         if ( name_of_col != NULL )
         {
            free (name_of_col );
            name_of_col = NULL;
         }
      }
   }

   misTrc ( T_FLOW, "--Statement [%s]", publish_data_cmd );
   stat = srvInitiateInline ( publish_data_cmd, &rp );

printf ( "end\n" );

end_of_function:
   if ( publish_data_cmd != NULL )
      free ( publish_data_cmd );

   if ( name_of_col != NULL )
      free ( name_of_col );

   if ( stat == eINVALID_ARGS )
      return srvErrorResults(stat, "Missing level argument", missing);
   else if ( stat != eOK )
      return srvErrorResults(stat, NULL );
   else
      return rp;
}

