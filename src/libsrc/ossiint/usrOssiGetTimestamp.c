#include <moca.h>

#include <stdio.h>
#include <string.h>

#include <mocaerr.h>
#include <srvlib.h>
#include <sqllib.h>

/*#include <varerr.h> */
#include <usrossierr.h>

LIBEXPORT 
RETURN_STRUCT* usrOssiGetTimestamp ( void )
{
   OS_TIME           now;
   double            ts;
   RETURN_STRUCT*    rp = NULL;

   osGetTime ( &now );
   ts = (double) (( (double)now.sec * 1000) + (double) now.msec);

   rp = srvResults 
          ( 
             eOK,
             "uc_ossi_ts", COMTYP_FLOAT, sizeof(double), ts,
             NULL
          );
   return rp;
}

