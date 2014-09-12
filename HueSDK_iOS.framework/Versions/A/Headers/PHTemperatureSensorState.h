/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHTemperatureSensorState : PHSensorState

/**
 Temperature in degree Celcius
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *temperature;

@end
