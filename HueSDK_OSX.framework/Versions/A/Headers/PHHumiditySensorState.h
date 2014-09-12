/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHHumiditySensorState : PHSensorState

/**
 Humidity in permille 
 Range: 0 - 1000
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *humidity;

@end
