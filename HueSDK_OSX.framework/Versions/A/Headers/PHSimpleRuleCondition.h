/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHRuleCondition.h"

typedef enum {
    // Config
    ATTRIBUTE_CONFIG_UTC,                      // value type: NSDate
    ATTRIBUTE_CONFIG_LOCALTIME,                // value type: NSDate
    
    /*
    // Lights
    ATTRIBUTE_LIGHT_STATE_ON,                  // value type: NSNumber (0 or 1)
    ATTRIBUTE_LIGHT_STATE_BRIGHTNESS,          // value type: NSNumber
    ATTRIBUTE_LIGHT_STATE_HUE,                 // value type: NSNumber
    ATTRIBUTE_LIGHT_STATE_SATURATION,          // value type: NSNumber
    ATTRIBUTE_LIGHT_STATE_CT,                  // value type: NSNumber
    ATTRIBUTE_LIGHT_STATE_REACHABLE,           // value type: NSNumber (0 or 1)
    */
    
    // Sensors
    ATTRIBUTE_SENSOR_STATE_LASTUPDATED,        // value type: NSDate
    ATTRIBUTE_SENSOR_STATE_TEMPERATURE,        // value type: NSNumber
    ATTRIBUTE_SENSOR_STATE_HUMIDITY,           // value type: NSNumber
    ATTRIBUTE_SENSOR_STATE_DAYLIGHT,           // value type: NSNumber (0 or 1)
    ATTRIBUTE_SENSOR_STATE_PRESENCE,           // value type: NSNumber (0 or 1)
    ATTRIBUTE_SENSOR_STATE_BUTTONEVENT,        // value type: NSNumber
    ATTRIBUTE_SENSOR_STATE_OPEN,               // value type: NSNumber (0 or 1)
    ATTRIBUTE_SENSOR_STATE_FLAG,               // value type: NSNumber (0 or 1)
    ATTRIBUTE_SENSOR_STATE_STATUS,             // value type: NSNumber
    
    ATTRIBUTE_SENSOR_CONFIG_BATTERY,           // value type: NSNumber
    ATTRIBUTE_SENSOR_CONFIG_REACHABLE,         // value type: NSNumber (0 or 1)
    ATTRIBUTE_SENSOR_CONFIG_ON,                // value type: NSNumber (0 or 1)
    ATTRIBUTE_SENSOR_CONFIG_SUNRISEOFFSET,     // value type: NSNumber
    ATTRIBUTE_SENSOR_CONFIG_SUNSETOFFSET,      // value type: NSNumber
    ATTRIBUTE_SENSOR_CONFIG_MOTIONSENSITIVITY, // value type: NSNumber
    ATTRIBUTE_SENSOR_CONFIG_RADIUS,            // value type: NSNumber
    
    ATTRIBUTE_UNKNOWN,
} PHSimpleRuleConditionAttribute;

@interface PHSimpleRuleCondition : PHRuleCondition

/**
 The attribute on which the rule should apply
 */
@property(nonatomic, assign) PHSimpleRuleConditionAttribute attribute;

/**
 The value for the address
 */
@property (nonatomic, strong) id value;

/**
 Initialize a new rule condition
 @param resourceIdentifier The identifier of the resource
 @param attribute The attribute of the resource
 @param value The value of the attribute
 @param operator The operator
 */
- (id)initWithIdentifier:(NSString *)resourceIdentifier andAttribute:(PHSimpleRuleConditionAttribute)attribute andValue:(id)value andOperator:(PHRuleConditionOperator)operator;

@end
