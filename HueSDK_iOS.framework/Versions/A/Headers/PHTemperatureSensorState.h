/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHTemperatureSensorState : PHSensorState

/**
 Current temperature in 0.01 degrees Celsius. (3000 is 30.00 degree)
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *temperature;

@end
