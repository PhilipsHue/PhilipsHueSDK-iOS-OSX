/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHGenericStatusSensorState : PHSensorState

/**
 The sensor status
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber* status;

@end
