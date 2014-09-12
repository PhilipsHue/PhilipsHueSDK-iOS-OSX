/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHGenericFlagSensorState : PHSensorState

/**
 The sensor state
 YES means on, NO means off.
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber* flag;

@end
