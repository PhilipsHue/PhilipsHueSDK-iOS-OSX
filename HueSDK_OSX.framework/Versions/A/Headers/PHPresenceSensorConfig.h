/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorConfig.h"

@interface PHPresenceSensorConfig : PHSensorConfig

/**
 Sensitivity of the sensor
 Range: 0 - 255
 
 Readwrite
 Only allowed for non CLIP sensor
 */
@property (nonatomic, strong) NSNumber *motionSensitivity;

@end
