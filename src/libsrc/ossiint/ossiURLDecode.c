#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>

LIBEXPORT 
RETURN_STRUCT* ossiURLDecode
               (
                  char*    i_url,
                  char*    i_cleanup_string,
                  char*    i_nonprint_char
               )
{
   long             stat = eOK;
   RETURN_STRUCT*   rp = NULL;
   char*            url_decoded = NULL;
   long             do_cleanup = 1;
   char             nonprint_char = ' ';

   /*Start */
   if ( i_cleanup_string && *i_cleanup_string == '0' )
      do_cleanup = 0;

   if ( i_nonprint_char && *i_nonprint_char )
      nonprint_char = *i_nonprint_char;

   misTrc ( T_FLOW, "ossiURLDecode:Input do_cleanup %d, nonprint as [%c], String[%s]",do_cleanup,nonprint_char, i_url );
   url_decoded = misHTTPDynURLDecode ( i_url );
   if ( url_decoded == NULL )
   {
      stat = eNO_MEMORY;
      goto end_of_function;
   }
   misTrc ( T_FLOW, "ossiURLDecode:Output String[%s]", url_decoded  );
   /*
    * Now cleanup the string for any chars that are out of printable range
    */
   if ( do_cleanup )
   {
      long ii;
      for ( ii = 0; ii < (long)strlen(url_decoded); ii++ )
      {
         if (!isprint( (int) url_decoded[ii] ) )
            url_decoded[ii] = nonprint_char;
      }
   }

end_of_function:
   rp = srvResults 
        ( 
           stat,
           "uc_url_decoded",  COMTYP_STRING, url_decoded ? strlen(url_decoded) : 0, url_decoded ? url_decoded : "",
           NULL
        );

   if ( url_decoded )
      free (url_decoded);
   return rp;
}