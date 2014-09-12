/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensor.h"

@class PHSwitchDeviceInfo;

@interface PHSwitch : PHSensor

/**
 Supported types:
 - CLIPSwitch
 - ZLLSwitch
 - ZGPSwitch
 */

@property (nonatomic, strong) PHSwitchDeviceInfo *deviceInfo;

@end
