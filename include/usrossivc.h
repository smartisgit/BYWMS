#ifndef USROSSIERR_H
#define USROSSIERR_H

/*
 *  User Error Codes 90000-99999.
 *  We are starting at 97000 to avoid any conflicts
 */ 

typedef enum UserOssiErrors
{	
    /**/
    eUSR_OSSI_ISSUE_USER_ALREADY_ASSIGNED     = 97005,
    eUSR_OSSI_ISSUE_ALREADY_ASSIGNED          = 97006,
    eUSR_OSSI_ISSUE_USER_NOT_ASSIGNED         = 97020,
    eUSR_OSSI_ISSUE_PK_NAMING_VIOLATION       = 97021,
    eUSR_OSSI_ISSUE_DEST_NOT_FOUND            = 97022,
    eUSR_OSSI_ISSUE_COMMIT_FAILED             = 97023,
    eUSR_OSSI_ISSUE_WRITE_FAILED              = 97024,
    /**/
    eUSR_RULE_SRTSEQ_MUST_BE_UNIQUE           = 97047,
    eUSR_ERROR_IN_MOCA_EXPRESSION             = 97048,
    /**/
    eUSR_OSSI_LAST_ONE_OSSI_ISSUE_DONT_REMOVE   = 97050
    
} UserOssiErrors;


#endif