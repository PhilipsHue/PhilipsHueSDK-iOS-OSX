/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

typedef enum {
    SENSOR_ALERT_UNKNOWN, // It is unkown what the current alert value is
    SENSOR_ALERT_NONE, // No alert active
    SENSOR_ALERT_SELECT, // Select alert (1 indication cycle) is active
    SENSOR_ALERT_LSELECT // Select alert (30 seconds of indication cycles) is active
} PHSensorAlertMode;

@interface PHSensorConfig : PHBridgeResource<NSCoding, NSCopying>

/**
 The url of the sensor
 */
@property (nonatomic, strong) NSString *url;

/**
 The battery state of the sensor
 Range: 0 - 100 (percentage)
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *battery;

/**
 Whether the sensor is reachable
 
 Readonly
 */
@property (nonatomic, strong) NSNumber *reachable;

/**
 Whether the sensor is activated
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *on;

/**
 The alert to set the sensor to.
 Options: "none" (no alert), "select" (1 indication cycle), "lselect" (indication cycles for 30 seconds or until value none is set)

 Readwrite. Not supported for CLIP sensors
 */
@property (nonatomic, assign) PHSensorAlertMode alert;

/**
 Whether the sensor is in usertest mode
 
 When set to on activates or extends usertest of device by 120s. In usertest sensors report changes in state faster and indicate state changes on device LED (if applicable)
 
 Readwrite. Not supported for CLIP sensors
 */
@property (nonatomic, strong) NSNumber *usertest;

@end
