#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>

LIBEXPORT 
RETURN_STRUCT* ossiURLEncode
               (
                  char*    i_url
               )
{
   long             stat = eOK;
   RETURN_STRUCT*   rp = NULL;
   char*            url_encoded = NULL;

   /*Start */
   misTrc ( T_FLOW, "ossiURLEncode:Input String[%s]", i_url );
   url_encoded = misHTTPDynURLEncode ( i_url );
   if ( url_encoded == NULL )
   {
      stat = eNO_MEMORY;
      goto end_of_function;
   }
   misTrc ( T_FLOW, "ossiURLEncode:Output String[%s]", url_encoded  );

end_of_function:
   rp = srvResults 
        ( 
           stat,
           "uc_url_encoded",  COMTYP_STRING, url_encoded ? strlen(url_encoded) : 0, url_encoded ? url_encoded : "",
           NULL
        );

   if ( url_encoded )
      free (url_encoded);
   return rp;
}