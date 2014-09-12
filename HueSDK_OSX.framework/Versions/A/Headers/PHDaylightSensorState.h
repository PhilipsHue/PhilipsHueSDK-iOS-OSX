/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHDaylightSensorState : PHSensorState

/**
 Whether between sunrise and sunset at the given GPS location
 YES between sunrise and sunset at the given GPS location on, NO means not between sunrise and sunset.
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *daylight;

@end
