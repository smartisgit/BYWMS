#include <moca.h>

#include <stdio.h>
#include <string.h>
#include <time.h>

#ifndef RELEASE_VERSION
#define RELEASE_VERSION ""
#endif

LIBEXPORT char *MOCAversion(void)
{
   return "OSSI_2005.4.2";
}

