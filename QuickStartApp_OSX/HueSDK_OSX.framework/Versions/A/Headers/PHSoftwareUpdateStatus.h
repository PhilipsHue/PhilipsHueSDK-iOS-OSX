/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@class PHSoftwareUpdateStatusDeviceTypes;

typedef enum {
    NO_UPDATE,
    UPDATE_DOWNLOADING,
    UPDATE_READY_FOR_INSTALL,
    UPDATE_INSTALLED
} UpdateState;

@interface PHSoftwareUpdateStatus : NSObject<NSCoding>

@property (nonatomic, assign) UpdateState updateState;

/**
 Check for update flag of the bridge
 */
@property (nonatomic, strong) NSNumber *checkForUpdate;

/**
 Details of device type specific updates available
 */
@property (nonatomic, strong) PHSoftwareUpdateStatusDeviceTypes *deviceTypes;


@property (nonatomic, strong) NSString *releaseNotesUrl;
@property (nonatomic, strong) NSString *updateText;


@end
