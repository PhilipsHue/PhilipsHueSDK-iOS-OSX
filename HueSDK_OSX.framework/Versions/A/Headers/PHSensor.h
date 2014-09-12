/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

@class PHSensorState;
@class PHSensorConfig;

/**
 A sensor and its settings
 */
@interface PHSensor : PHBridgeResource<NSCoding, NSCopying>

/**
 State of the sensor
 */
@property (nonatomic, strong) PHSensorState *state;

/**
 Configuration of the sensor
 */
@property (nonatomic, strong) PHSensorConfig *config;

/**
 Sensor type
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSString *type;

/**
 Unqiue model identifier of the sensor
 Range: 6 - 32 chars
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSString *modelId;

/**
 Manufacturer name
 Range: 1 - 16 chars
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSString *manufacturerName;

/**
 Software version of the sensor
 Range: 1 - 16 chars
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSString *swversion;

/**
 Unique identifier of the sensor
 Range: 6 - 32 chars
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSString *uniqueId;

@end
