#include <moca.h>

#include <stdio.h>
#include <string.h>
#include <time.h>

#ifndef RELEASE_VERSION
#define RELEASE_VERSION ""
#endif

LIBEXPORT char *MOCAversion(void)
{
    if (RELEASE_VERSION[0] == '\0')
        return __DATE__;
    else
        return RELEASE_VERSION;
}
