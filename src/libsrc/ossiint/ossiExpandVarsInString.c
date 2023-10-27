#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>

#define VARNAME_SET "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_"
#define FUNC_SET    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_'(),#"

LIBEXPORT 
RETURN_STRUCT* ossiExpandVarsInString
               (
                  char*    i_string
               )
{
   long             stat = eOK;
   RETURN_STRUCT*   rp = NULL;
   /*char*            cmd = NULL; */
   char*            pp = NULL;
   char*            pp_d = NULL;
   char             varname [2000];
   size_t           varname_len;

   char             var_modifier_ind;
   char             var_modifier [ 200 ];
   size_t           var_modifier_len;
   long             var_modifier_raw;
   long             var_modifier_rawdays;
   long             var_modifier_asis;
   long             var_modifier_func;

   char             dtype;
   void*            data;

   char*            res = NULL;

   RETURN_STRUCT* f_rp = NULL;
   mocaDataRes*   f_res;
   mocaDataRow*   f_row;

   char*          var_set;


   /* Start */

   if ( i_string != NULL && strlen(i_string) > 0 )
   {
      pp = i_string;
      for ( ;; )
      {
         var_modifier_raw = 0;
         var_modifier_asis = 0;
         var_modifier_rawdays = 0;
         var_modifier_func = 0;

         /* Find @ */
         pp_d = strchr( pp, '@' );

         if ( pp_d != NULL )
         {
            /*
             * See if after pp_d we have a # this implies an expression will follow
             * Push the pointer forward
             */
            if ( pp_d[1] == '#' )
            {
               var_set = FUNC_SET;
               var_modifier_func = 1;
            }
            else
               var_set = VARNAME_SET;

            /* Copy the target string just before the @ */
            misDynStrncat ( &res, pp, pp_d - pp );

            /* See what variable name it really is.  For variables we get variable for func we get the whole expression */
            varname_len = strspn ( &pp_d[1], var_set );
   
            if ( varname_len > 0 )
            {
               memset ( var_modifier, '\0', sizeof var_modifier );
               var_modifier_ind = *(pp_d + varname_len + 1);

               if ( var_modifier_ind == ':' )
               {
                  /* Modifier always conforms to the static VARNAME_SET */
                  var_modifier_len = strspn ( pp_d + varname_len + 2, VARNAME_SET );
                  strncpy( var_modifier, pp_d + varname_len + 2, MIN(var_modifier_len,(sizeof var_modifier)-1));
               }

               /*
                * Only valid modifier for us is raw
                */
               if ( misCiStrcmp(var_modifier, "rawdays") == 0 )
                  var_modifier_rawdays = 1;
               else if ( misCiStrcmp(var_modifier, "raw" ) == 0 )
                  var_modifier_raw = 1;
               else if ( misCiStrcmp(var_modifier, "asis" ) == 0 )
                  var_modifier_asis = 1;
               else if ( var_modifier_func )
                  ;
               else
                  var_modifier_len = 0;

               memset ( varname, '\0', sizeof varname );
               strncpy ( varname, &pp_d[1], MIN(varname_len,(sizeof varname)-1) );

               misTrc ( T_SRVARGS, ">>>Found variable [%s] len %d modifier [%s] - raw = %d asis = %d rawdays = %d func=%d", 
                        varname,
                        varname_len,
                        var_modifier,
                        var_modifier_raw,
                        var_modifier_asis,
                        var_modifier_rawdays,
                        var_modifier_func
                      );

               /*
                * If we are a function, then execute function otherwise get from stack
                */
               if ( var_modifier_func )
               {
                  char* buf = NULL;
                   
                  if ( (buf = malloc ( strlen(varname) + 200 )) != NULL )
                  {
                     /* Go from one after varname because of leading # */
                     sprintf ( buf, "publish data where res = %s", &(varname[1]) );
                     stat = srvInitiateInline (buf, &f_rp );
                     if ( stat == eOK )
                     {
                        if ( (f_res = srvGetResults ( f_rp )) )
                        {
                           if ( f_row = sqlGetRow ( f_res ) )
                           {
                              data = sqlGetString ( f_res, f_row, "res" );
                              dtype= COMTYP_CHAR;
                              misTrc ( T_SRVARGS, ">>>>>>Eval [%s] = [%s]", varname, (char*) (data?data:"") );
                           }
                        }
                     }
                  }
                  if ( buf != NULL )
                     free ( buf );
               }
               else
               {
                  /* Find the variable in moca stack */
                  stat = srvGetNeededElement ( varname, NULL, &dtype, &data );
   
                  misTrc ( T_SRVARGS, ">>>>>>Status of find %d type %c",
                           stat, dtype );
               }

               {
                  char* repl_data = NULL;
                  if ( dtype == COMTYP_CHAR || stat != eOK || dtype == COMTYP_DATTIM )
                  {
                     if ( var_modifier_raw  || var_modifier_rawdays || var_modifier_asis )
                     {
                        if ( var_modifier_raw )
                           misDynStrcpy ( &repl_data, (char*) data );
                        else if ( var_modifier_rawdays )
                        {
                           misDynStrcpy ( &repl_data, "/*=moca_util.days(*/ " );
                           misDynStrcat ( &repl_data, (char*) data );
                           misDynStrcat ( &repl_data, "/*=)*/"  );
                        }
                        else if ( var_modifier_asis )
                           misDynStrncat ( &repl_data, pp_d, varname_len + 1 );
                     }
                     else
                     {
                        long ii;
                        long len;
   
                        if ( stat == eOK )
                        {
                           misDynStrcpy ( &repl_data, "'" );
                           len = (long)strlen( (char*) data ? data : "" );
                           for ( ii = 0; ii < len; ii++ )
                           {
                              if ( ((char*)data)[ii] == '\'' )
                                 misDynStrcat ( &repl_data, "''" );
                              else
                                 misDynStrncat ( &repl_data, &((char*)data)[ii],1 );
                           }
                           misDynStrcat ( &repl_data, "'" );
                        }
                        else
                        {
                           misDynStrcpy ( &repl_data, " null " );
                        }
                     }
                  }
                  else if ( dtype == COMTYP_INT || dtype == COMTYP_LONG )
                  {
                     repl_data = malloc ( 100 );
                     sprintf ( repl_data, "%-d", *((long*)data) );
                  }
                  else if ( dtype == COMTYP_FLOAT )
                  {
                     repl_data = malloc ( 100 );
                     sprintf ( repl_data, "%g", *((double*)data) );
                  }
   
                  misDynStrcat ( &res, (char*) repl_data );
 
                  if ( repl_data )
                     free ( repl_data );
               } /* variable found */
               /*
               else
               {
                  misDynStrncat ( &res, pp_d, varname_len + 1 );
               }
               */

               /*
                * Free stuff that we got in this round 
                */
               if ( f_rp != NULL )
               {
                  srvFreeMemory(SRVRET_STRUCT, f_rp );
                  f_rp = NULL;
               }

               /* move pp beyond and of the varname */
               pp = pp_d + varname_len + 1 + (var_modifier_len > 0 ? (var_modifier_len + 1) : 0) ;
            } /* varname found */
            else
            {
               misDynStrcat ( &res, "@" );
               pp = pp_d + 1;
            } /* no varname found after @ */
         } /* @ found */
         else
         {
            misDynStrcat ( &res, pp );
            break;
         } /* no @ found */
      } /* forever */
   }

   rp = srvResults 
          ( 
             eOK,
             "sl_expanded", COMTYP_STRING, res != NULL ? strlen(res) : 0, res != NULL ? res : "",
             NULL
          );

   free (res);
   return rp;
}

