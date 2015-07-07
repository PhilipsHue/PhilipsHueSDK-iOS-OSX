/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHHumiditySensorState : PHSensorState

/**
 Current humidity in 0.01% steps (e.g. 2000 is 20%)
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *humidity;

@end
