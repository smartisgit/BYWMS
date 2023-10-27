#ifndef USROSSIERR_H
#define USROSSIERR_H

/*
 *  User Error Codes 90000-99999.
 *  We are starting at 97000 to avoid any conflicts
 */

typedef enum UserOssiErrors
{
    eUSR_OSSI_WRKQUE_CANOT_BE_SUSPENDED    = 96500,
    eUSR_OSSI_WRKQUE_CANNOT_MOVE_FROM_CANP = 96501,
    /* end*/
    eUSR_OSSI_LAST_TOOLS_ONE_DONT_REMOVE            = 99999
} UserOssiErrors;


#endif