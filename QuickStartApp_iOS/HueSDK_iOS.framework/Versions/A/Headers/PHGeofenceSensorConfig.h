/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorConfig.h"

@interface PHGeofenceSensorConfig : PHSensorConfig

/**
 Radius in meters
 
 Readwrite
 */
@property (nonatomic, strong) NSNumber *radius;

/**
 Device name of the device triggering the fence
 Range: 1 - 40 chars
 
 Readwrite
 */
@property (nonatomic, strong) NSString *device;

@end
