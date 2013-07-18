/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    NO_UPDATE,
    UPDATE_DOWNLOADING,
    UPDATE_READY_FOR_INSTALL,
    UPDATE_INSTALLED
} UpdateState;

@interface PHSoftwareUpdateStatus : NSObject

@property (nonatomic, assign) UpdateState updateState;
@property (nonatomic, strong) NSString *releaseNotesUrl;
@property (nonatomic, strong) NSString *updateText;

@end
