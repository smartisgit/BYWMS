#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>

/*#include <varerr.h> */
#include <usrossierr.h>

LIBEXPORT 
RETURN_STRUCT* usrOssiConvertPointerToType 
               ( 
                  void** pointer,
                  char*  output_type,
                  char*  output_column
               )
{
   RETURN_STRUCT*    rp = NULL;
   long stat = eOK;

   void*    my_pointer;
   char*    ret  = NULL;

   my_pointer = *pointer;

   if ( misCiStrcmp ( output_type, "hex" ) == 0 )
   {
      if ( (ret = (char*) calloc ( 100, sizeof(char) )) == NULL )
      {
         stat = eNO_MEMORY;
         goto end_of_function;
      }
      sprintf ( ret, "%p", my_pointer );
   }
   else if ( misCiStrcmp ( output_type, "dec" ) == 0 )
   {
      if ( (ret = (char*) calloc ( 100, sizeof(char) )) == NULL )
      {
         stat = eNO_MEMORY;
         goto end_of_function;
      }
      /*sprintf ( ret, "%lu", (unsigned long)my_pointer );*/
      sprintf ( ret, "%lu", (unsigned long) 0 );
   }
   else if ( misCiStrncmp ( output_type, "string", 6 ) == 0 ) 
   {
      char str_len_str [100];
      long str_len;

      /* output_type will be something like string10 implying get 10 chars */
      strcpy ( str_len_str, &(output_type[6]) );
      str_len = atol (str_len_str );

      misTrc ( T_FLOW, "Allocating buffer of %d for pointer %p", str_len + 1, my_pointer );
      if ( (ret = (char*) calloc ( str_len + 1, sizeof(char) )) == NULL )
      {
         stat = eNO_MEMORY;
         goto end_of_function;
      }
      misTrc ( T_FLOW,  "Successfully created pointer %p", ret );

      sprintf ( ret, "%*s", str_len, (char*) my_pointer );
   }


end_of_function:
   rp = srvResults 
          ( 
             stat,
             output_column, COMTYP_STRING, strlen(ret), ret,
             NULL
          );
   if ( ret != NULL )
   {
      free ( ret );
      ret = NULL;
   }

   return rp;
}
