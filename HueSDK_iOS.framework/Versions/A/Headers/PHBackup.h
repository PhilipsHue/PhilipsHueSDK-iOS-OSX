/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    BACKUP_STATUS_IDLE,
    BACKUP_STATUS_START_MIGRATION,
    BACKUP_STATUS_FILE_READY_DISABLED,
    BACKUP_STATUS_PREPARE_RESTORE,
    BACKUP_STATUS_RESTORING,
} BackupState;

@interface PHBackup : NSObject<NSCoding>

/**
 Status of backup/restore
 Writable only: BACKUP_STATUS_START_MIGRATION
 */
@property (nonatomic, assign) BackupState backupState;

/**
 Specifies the last error source if the backup
 statemachine has detected an internal error. Cleared
 at the start of a backup import or export.
 */
@property (nonatomic, strong) NSNumber *errorCode;

@end
