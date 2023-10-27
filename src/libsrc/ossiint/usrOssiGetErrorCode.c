#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>
/*#include <dbcalls.h>*/

#include <varerr.h>
#include <usrossierr.h>

typedef struct
{
   char*    error_sym;
   char*    error_code;
} l_ossi_error_code_typ;

static l_ossi_error_code_typ*  g_error_code_array = NULL;
static long                    g_error_code_array_siz = 0;

static char**                  g_dir_list = NULL;
static long                    g_dir_list_siz = 0;

static long                    g_registered_at_exit = 0;

#define DEFAULT_DIR_LIST_FOR_ERRORS "$LESDIR/include/usrossierr.h;$LESDIR/include/usrossivc.h;$LESDIR/include/usrossiarch.h;$LESDIR/include/usrossitools.h;$LESDIR/include/usrossismartmhe.h;$LESDIR/include/usrerr.h;$LESDIR/include/varerr.h;\
$MOCADIR/include/mocaerr.h;$MCSDIR/include/mcserr.h;\
$SALDIR/include/salerr.h;$DCSDIR/include/dcserr.h;$SLOTDIR/include/sloterr.h"


static void usrOssiGetErrorCode_Free (void)
{
   long ii;

   misTrc  ( T_FLOW, "usrOssiGetErrorCode_Free Started with pointers %p/%p sizes %d/%d",
             g_error_code_array, g_dir_list,
             g_error_code_array_siz, g_dir_list_siz );

   if ( g_error_code_array != NULL )
   {
      for ( ii = 0; ii < g_error_code_array_siz; ii++ )
      {
         if ( g_error_code_array[ii].error_sym != NULL )
            free ( g_error_code_array[ii].error_sym );

         if ( g_error_code_array[ii].error_code != NULL )
            free ( g_error_code_array[ii].error_code );
      }
      free ( g_error_code_array );
   }

   if ( g_dir_list != NULL )
   {
      for ( ii = 0; ii < g_dir_list_siz; ii++ )
      {
         if ( g_dir_list[ii] != NULL )
            free ( g_dir_list[ii] );
      }
      free ( g_dir_list );
   }

   g_error_code_array_siz = 0;
   g_error_code_array = NULL;

   g_dir_list_siz = 0;
   g_dir_list = NULL;

   misTrc  ( T_FLOW, "usrOssiGetErrorCode_Free End" );

}


LIBEXPORT 
RETURN_STRUCT* usrOssiGetErrorCode ( char* i_error_sym )
{
   long           ii; 
   char*          r_error_code = NULL;
   RETURN_STRUCT* rp = NULL;

   misTrc  ( T_FLOW, "usrOssiGetErrorCode STARTED.  Look for [%s]", i_error_sym );

   if ( !g_registered_at_exit )
   {
      misTrc  ( T_FLOW, "---Registering free function" );
      osAtexit(usrOssiGetErrorCode_Free);
      g_registered_at_exit = 1;
   }

   if ( g_dir_list == NULL )
   {
      char* ss;
      char* pp;
      char* end_ptr;
      char  one_dir [2000];

      char* dir_list = NULL;

      if ( (pp=osGetVar ("UC_OSSI_DIR_LIST_FOR_ERRORS")) != NULL )
         misDynStrcpy ( &dir_list, pp );
      else
         misDynStrcpy ( &dir_list, DEFAULT_DIR_LIST_FOR_ERRORS );


      end_ptr = &(dir_list[strlen(dir_list)]);      

      misTrc  ( T_FLOW, "usrOssiGetErrorCode -- First time, load directory list [%s]", dir_list );

      for ( ii = 0, ss = dir_list; ss < end_ptr;ii++ )
      {
         if ( (pp = strchr(ss, ';' )) == NULL )
            pp = end_ptr;

         /* Make the delimiter a ; so that we can use straight string functions */
         *pp = '\0';

         misExpandVars ( one_dir, ss, (sizeof one_dir) - 1, NULL );

         misTrc  ( T_FLOW, "---Name [%s], Expanded to [%s]", ss, one_dir );

         if ( strlen(one_dir) > 0 )
         {
            /* Make room for this */         
            g_dir_list = (char**) realloc ( g_dir_list, sizeof(char*) * (ii+1) );  

            g_dir_list[ii] = NULL;
            misDynStrcpy ( &(g_dir_list[ii]), one_dir );
         }

         ss = pp + 1;
      }
      g_dir_list_siz = ii;
      
      
      free ( dir_list );
   }

   /* 
    * First look for symbol in our cache 
    */
   misTrc ( T_FLOW, "Look in cache.  Current size = %d", g_error_code_array_siz );

   for ( ii = 0; ii < g_error_code_array_siz; ii++ )
   {
      if ( misCiStrcmp ( g_error_code_array[ii].error_sym, i_error_sym ) == 0 )
      {
         r_error_code = g_error_code_array[ii].error_code;
         break;
      }
   }

   misTrc ( T_FLOW, "Cache found ptr = %p - #directories = %d", r_error_code, g_dir_list_siz );


   /*
    * Look for the error symbol in the file.  If found return the code next to it
    */
   if ( r_error_code == NULL )
   {
      for ( ii = 0; ii < g_dir_list_siz; ii++ )
      {
         FILE*  fp = NULL;
         char   one_line [2000];
         char*  eq_ptr;
         char*  cd_ptr;
         char*  coma_ptr;

         misTrc ( T_FLOW, "---Lookup file [%s]", g_dir_list[ii] );

         if ( (fp = fopen ( g_dir_list[ii], "r" )) != NULL )
         {
                        
            for ( ;; )
            {
               fgets ( one_line, (sizeof one_line) - 1, fp );

               if ( feof(fp) )
                  break;

               /* Look for = on line */
               if ( (eq_ptr = strchr ( one_line, '=' )) != NULL )
               {
                  misTrc ( T_SRVARGS, "------Line with = [%s]", one_line );

                  *eq_ptr = '\0';
                  misTrimLR(one_line);

                  misTrc ( T_SRVARGS, "---------Error Symbol = [%s]", one_line );

                  if ( misCiStrcmp( one_line, i_error_sym ) == 0 )
                  {
                     cd_ptr = eq_ptr + 1;
 
                     if ( (coma_ptr = strchr(cd_ptr, ',')) != NULL )
                        *coma_ptr = '\0';

                     misTrimLR ( cd_ptr );

                     misTrc ( T_SRVARGS, "---------Error Code = [%s]", cd_ptr );

                     if ( strlen(cd_ptr) > 0 )
                     {
                        g_error_code_array = (l_ossi_error_code_typ*) realloc ( g_error_code_array, sizeof(l_ossi_error_code_typ)* ( g_error_code_array_siz + 1 ) );
                        
                        g_error_code_array[g_error_code_array_siz].error_sym  = NULL;
                        g_error_code_array[g_error_code_array_siz].error_code = NULL;

                        misDynStrcpy ( &(g_error_code_array[g_error_code_array_siz].error_sym),  one_line );
                        misDynStrcpy ( &(g_error_code_array[g_error_code_array_siz].error_code), cd_ptr   );
 
                        r_error_code = g_error_code_array[g_error_code_array_siz].error_code;
                        g_error_code_array_siz++;
                      
                        break;  
                     }
                  }
               }
            }

            fclose(fp);
         }

         if ( r_error_code != NULL )
            break;
      }
   }

   misTrc ( T_FLOW, "Final lookup result %p [%s]", r_error_code, r_error_code != NULL ? r_error_code : "<null>" );


   if ( r_error_code != NULL )
      rp = srvResults 
             ( 
                eOK,
                "uc_ossi_error_code", COMTYP_STRING, strlen(r_error_code), r_error_code,
                NULL
             );
   else
   {
      char err_info [1000];
      sprintf ( err_info, "Could not find code for symbol [%s]", i_error_sym );
      rp = srvErrorResults(eERROR, err_info, NULL);
   }

   return rp;
}
