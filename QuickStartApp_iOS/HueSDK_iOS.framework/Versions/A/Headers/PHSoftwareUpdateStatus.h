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

/*
 Flag that turns to true when update is available. Can only be updated when its state is true and it is being set to false. All other transitions are invalid and will return an error. 
 Updating this flag constitutes acceptance by the app of notification of the firmware update
 */
@property (nonatomic, strong) NSNumber *notify;

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
