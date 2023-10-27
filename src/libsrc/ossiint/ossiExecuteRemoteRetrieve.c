#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>

/*#include <varerr.h> */

#define MY_TAG_OPENQUERY        "use_openquery"
#define MY_TAG_VIEW_NAME_PREFIX "view_name_prefix"
#define MY_TAG_OUTSIDE_TRANS    "outside_trans"
#define MY_TAG_DB_LINKED_SERVER "db_linked_server"

char* ossiEscapeChar ( char* i_str, char i_ch )
{
   long  len, ii, jj;
   char* ret = NULL;

   len = (long) strlen(i_str);

   for ( ii = 0, jj = 0; ii <= len; ii++ )
   {
      if ( (ret = realloc ( ret, (jj+1)*(sizeof (char*)) )) == NULL )
         break;

      ret [jj++] = i_str[ii];

      /*
       * If this was an escape character, add it again
       */
      if ( i_str[ii] == i_ch )
      {
         if ( (ret = realloc ( ret, (jj+1)*(sizeof (char*)) )) == NULL )
            break;

         ret [jj++] = i_str[ii];
      }
   }

   ret[jj] = '\0';


   return ret;
}


static long my_is_set ( char* val )
{
   return toupper(val[0]) == 'Y' || toupper(val[0]) == '1' || toupper(val[0]) == 'T';
}

LIBEXPORT 
RETURN_STRUCT* ossiExecuteRemoteRetrieve
               (
                  char*    i_cmd,
                  char*    i_linked_server,
                  char*    i_outside_trans,
                  char*    i_use_openquery,
                  char*    i_view_name_prefix,
                  char*    i_db_linked_server,
                  char*    i_describe_only

                  /*
                   * Additional arguments may be given as
                   * ossi_col_
                   */
               )
{
   long             stat = eOK;
   RETURN_STRUCT*   rp = NULL;
   RETURN_STRUCT*   rp_opt = NULL;
   RETURN_STRUCT*   rp_desc = NULL;
   RETURN_STRUCT*   rp_macro = NULL;
   RETURN_STRUCT*   rp_sys = NULL;
   char*            cmd = NULL;
   char*            use_cmd = NULL;

   int              dbtype;

   char             linked_server_var [100];
   char*            pp_linked_server_data;

   long             env_use_openquery;
   char             env_view_name_prefix [100];
   long             env_outside_trans;
   char             env_db_linked_server [100];

   long             describe_only;
   char*            use_data = NULL;


   /* Start */
   env_use_openquery = -1;
   env_outside_trans = -1;
   strcpy ( env_view_name_prefix, "" );
   strcpy ( env_db_linked_server, "" );

   describe_only = (i_describe_only != NULL && my_is_set (i_describe_only) );

   /* Get the database type */
   if ( (stat = dbInfo ( &dbtype )) != eOK )
      goto end_of_function;

   /*
    * Read options from parameters
    */
   if ( i_use_openquery && strlen(i_use_openquery) > 0 )
      env_use_openquery = my_is_set ( i_use_openquery );

   if ( i_view_name_prefix && strlen(i_view_name_prefix) > 0 )
      strcpy ( env_view_name_prefix, i_view_name_prefix );

   if ( i_outside_trans && strlen(i_outside_trans) > 0 )
      env_outside_trans = my_is_set ( i_outside_trans );

   if ( i_db_linked_server && strlen(i_db_linked_server) > 0 )
      strcpy ( env_db_linked_server, i_db_linked_server );



   /*
    * Setup the result set for describe_only case
    */
   if ( describe_only )
   {
      rp_desc = srvResultsInit(eOK, 
                               "sql_crsr_col", COMTYP_CHAR,    40,
                               "data_typ_cd",  COMTYP_CHAR,    10,
                               "len",          COMTYP_INT,     sizeof(long),
                               NULL
                              );
   }
         
   sprintf ( linked_server_var, "OSSI_LINKED_SERVER_%s", i_linked_server != NULL ? i_linked_server : "" );

   misTrc ( T_SRVARGS, ">>>Environment variable for linked server options = [%s]", linked_server_var );
   /*
    * If we find this environment variable, it will be a list like x=y;a=b
    * Read through it and get the values we are interested in
    */
   if ( (pp_linked_server_data = osGetVar ( linked_server_var )) != NULL )
   {
      mocaDataRes* res;
      mocaDataRow* row;

      char         name [100];
      char         val  [300];

      misTrc ( T_SRVARGS, ">>>Linked Server variable is [%s]", pp_linked_server_data );

      stat = srvInitiateCommandFormat ( &rp_opt, 
                                        "ossi parse name value list where sl_list = '%s'",
                                        pp_linked_server_data,
                                        NULL
                                      );

      if ( stat != eOK )
      {
         misTrc ( T_SRVARGS, ">>>Error %d while reading through option [%s]", stat, pp_linked_server_data );
         goto end_of_function;
      }

      res = srvGetResults ( rp_opt );

      /*
       * Go through all options
       */
      for ( row = sqlGetRow ( res ); row != NULL; row = sqlGetNextRow ( row ) )
      {
         strcpy ( name, sqlGetString ( res, row, "name" ) );
         strcpy ( val,  sqlGetString ( res, row, "value") );

         misTrc ( T_SRVARGS, ">>>>>> Read option %s = %s", name, val );

         if ( misCiStrcmp ( name, MY_TAG_OPENQUERY ) == 0 && env_use_openquery < 0 )
            env_use_openquery = my_is_set ( val );

         else if ( misCiStrcmp ( name, MY_TAG_VIEW_NAME_PREFIX ) == 0 && strlen(env_view_name_prefix) == 0 )
            strcpy ( env_view_name_prefix, val );

         else if ( misCiStrcmp ( name, MY_TAG_OUTSIDE_TRANS ) == 0 && env_outside_trans < 0 )
            env_outside_trans = my_is_set ( val );

         else if ( misCiStrcmp ( name, MY_TAG_DB_LINKED_SERVER ) == 0 && strlen(env_db_linked_server) == 0 )
            strcpy ( env_db_linked_server, val );
      }
   } /* have linked server options */

   misTrc ( T_SRVARGS, ">>>Options to execute command are:" );
   misTrc ( T_SRVARGS, ">>>--- View Prefix [%s], openquery[%d], outside_trans [%d], db_link [%s]",
            env_view_name_prefix,
            env_use_openquery,
            env_outside_trans,
            env_db_linked_server
          );

   /*
    * If linked sevrer is given our sql changes to use openquery 
    * syntax
    */
   if ( i_linked_server && strlen(i_linked_server) > 0 && dbtype == MOCA_DB_MSSQL && env_use_openquery )
   {
      misTrc ( T_SRVARGS, ">>>If running on SQLServer and have a linked server then run using openquery" );

      /*
       * The first part gives us the indicator variables for the system if one is passed
       */
      use_cmd = malloc ( 1400 );
      sprintf ( use_cmd, 
                "publish data where my_cmd = substr(@sl_cmd,2,len(@sl_cmd)-2)\n"
                "|"
                "ossi expand vars in string where sl_string = @my_cmd\n"
                "|"
                "publish data where sl_expanded = ossi_replace(@sl_expanded, '%s', '')\n"
                "|"
                "[select * from openquery(%s,@sl_expanded)]",
                env_view_name_prefix,
                env_db_linked_server
              );
   }
   else
   {
      misDynStrcpy ( &use_cmd, i_cmd );
   }

   misTrc ( T_SRVARGS, ">>>>>>The command has been modified as [%s]", use_cmd );

   /*
    * If we are outside a transaction, the command will be run remotely
    * and then on sqlserver we will need to turn off implicit_transactions
    */
   if ( env_outside_trans )
   {
      cmd = malloc ( strlen(use_cmd) + 1100 );
      sprintf ( cmd,
                "ossi get ind vars catch(@?)\n"
                "|"
                " publish data where sl_cmd=@sl_cmd\n"
                " | get connection manager configuration\n"
                " |\n"
                " Remote ( '127.0.0.1:' || @port )\n"
                " {\n"
                "    try\n"
                "    {\n"
                "       if ( dbtype = 'MSSQL' )\n"
                "       {\n"
                "          [set implicit_transactions off]\n"
                "          ;\n"
                "          %s\n"
                "       }\n"
                "    }\n"
                "    finally\n"
                "    {\n"
                "       if ( dbtype = 'MSSQL' )\n"
                "          [set implicit_transactions on]\n"
                "    }\n"
                " }\n"
                ,
                use_cmd
              );
   }
   else
   {
      cmd = malloc ( strlen(i_cmd) + 1 );
      strcpy ( cmd, use_cmd );
   }

   /*
    * Now concatenate a publish data at the end with additional things passed to this command
    */
   {
      SRV_ARGSLIST*    args = NULL;
      char             name[100];
      int              oper;
      char             dtype;
      void*            data;

      char             use_name [100];

      /*
       * Add a filter data to put additional columns
       */
      misDynStrcat ( &cmd, 
                     "\n| filter data where "
                     "     sys_num_absent_ind_char = @sys_num_absent_ind_char"
                     " and sys_num_null_ind_char   = @sys_num_null_ind_char"
                     " and sys_dt_absent_ind_char  = @sys_dt_absent_ind_char"
                     " and sys_nochg_ind_char      = @sys_nochg_ind_char"
                     " and sys_null_ind_char       = @sys_null_ind_char"
                     " and sys_absent_ind_char     = @sys_absent_ind_char"
                   );


      misTrc ( T_SRVARGS, "##### ENUMERATING ADDITIONAL COLUMNS #####" );
      for ( ;; )
      {
         stat = srvEnumerateArgList(&args, name, &oper, &data, &dtype);

         if ( stat != eOK )
            break;

         misTrc ( T_SRVARGS, "#####>>Parameter [%s] data type [%c] val ptr %p", name, dtype, data ); 

         if ( dtype == COMTYP_STRING && data != NULL )
         {
            misTrc ( T_SRVARGS, "#####>>Type is string so handle this val [%s]", data );

            /*
             * See if the data refers to a macro (^ in string).  If so expand it 
             */
            if ( strchr(data,'^') != NULL )
            {
               mocaDataRes* res;
               mocaDataRow* row;

               char*        escaped_data = NULL;

               if ( (escaped_data = ossiEscapeChar ( (char*)data, '\'' )) == NULL )
               {
                  stat = eNO_MEMORY;
                  goto end_of_function;
               }

               misTrc ( T_SRVARGS, "#####>>>>Escape the quotes to get Data [%s]", escaped_data );
               stat = srvInitiateCommandFormat ( &rp_macro, 
                                                 "ossi expand int macro where sl_expr = '%s'",
                                                 escaped_data,
                                                 NULL
                                               );
               free ( escaped_data ); escaped_data = NULL;
               if ( stat != eOK )
                  goto end_of_function;

               if ( (res = srvGetResults ( rp_macro )) != NULL )
               {
                  if ( (row=sqlGetRow(res)) != NULL )
                  {
                     misDynStrcpy ( &use_data, sqlGetString ( res, row, "sl_macro_expanded" ) );
                     if ( use_data == NULL )
                     {
                        stat = eNO_MEMORY;
                        goto end_of_function;
                     }

                     misTrc ( T_SRVARGS, "#####>>>>Expanded Escape Sequence is [%s]", use_data);
                  }
               }

               if ( rp_macro != NULL )
               {
                  srvFreeMemory(SRVRET_STRUCT, rp_macro );
                  rp_macro = NULL;
               }
            } /* found a ^ in data */

            if ( misCiStrncmp ( name, "ossi_col_", 9 ) == 0 )
               strcpy ( use_name, &(name[9]) );
            else
               strcpy ( use_name, name );

            misDynStrcat ( &cmd, "\nand " );
            misDynStrcat ( &cmd, use_name );
            misDynStrcat ( &cmd, " = " );

            if ( use_data != NULL )
            {
               misDynStrcat ( &cmd, use_data );
               free ( use_data );
               use_data = NULL;
            }
            else
               misDynStrcat ( &cmd, data ? data : "null" );

            /*
             * If describing only, add these columns to the resultset
             */
            srvResultsAdd ( rp_desc,
                            use_name,
                            "C",
                            100,
                            NULL
                          );
         } /* valid parameter */
         else
         {
            misTrc ( T_SRVARGS, "#####>>Ignored because either data is null or type is not string" );
         }
      } /* next */

      if ( args ) 
         srvFreeArgList(args);
   }

   if ( cmd != NULL )
   {
      misTrc ( T_SRVARGS, ">>>>>>Now run command [%s]", cmd );
      stat = srvInitiateInline ( cmd, &rp );
      free (cmd );

      /*
       * If describing data; then get the resultset
       */
      if ( describe_only )
      {
         mocaDataRes* res;
         int          ii;
         char         dtype;
         char         str_dtype   [11];
         char         str_colname [41];

         if ( (res = srvGetResults ( rp )) != NULL )
         {
            for ( ii = 0; ii < sqlGetNumColumns ( res ); ii++ )
            {
               strcpy ( str_colname, sqlGetColumnName ( res, ii) );

               dtype = sqlGetDataType ( res, str_colname );
               if ( dtype == COMTYP_INT || dtype == COMTYP_LONG || dtype == COMTYP_FLOAT )
                  strcpy ( str_dtype, "N" );
               else if ( dtype == COMTYP_DATTIM )
                  strcpy ( str_dtype, "D" );
               else
                  strcpy ( str_dtype, "C" );


               srvResultsAdd ( rp_desc,
                               str_colname,
                               str_dtype,
                               sqlGetDefinedColumnLen  (res, str_colname ),
                               NULL
                             );
            } /* next ii */
         } /* res is there */
      } /* only interested in describing */
   } /* cmd given */

   /*
    * Add these to our describe only result set
    */
   if ( describe_only )
   {
      srvResultsAdd ( rp_desc, "sys_num_absent_ind_char", "C", 100, NULL);
      srvResultsAdd ( rp_desc, "sys_num_null_ind_char", "C", 100, NULL);
      srvResultsAdd ( rp_desc, "sys_dt_absent_ind_char", "C", 100, NULL);
      srvResultsAdd ( rp_desc, "sys_nochg_ind_char", "C", 100, NULL);
      srvResultsAdd ( rp_desc, "sys_null_ind_char", "C", 100, NULL);
      srvResultsAdd ( rp_desc, "sys_absent_ind_char", "C", 100, NULL);
   }

   if ( use_cmd != NULL )
      free ( use_cmd );

end_of_function:
   if ( rp_opt != NULL )
      srvFreeMemory(SRVRET_STRUCT, rp_opt );

   if ( rp_macro != NULL )
      srvFreeMemory(SRVRET_STRUCT, rp_macro );
   
   if ( rp_sys != NULL )
      srvFreeMemory(SRVRET_STRUCT, rp_sys );

   if ( use_data != NULL )
      free ( use_data );

   if ( describe_only )
      srvFreeMemory(SRVRET_STRUCT, rp );


   return ( describe_only ? rp_desc : rp );
}

