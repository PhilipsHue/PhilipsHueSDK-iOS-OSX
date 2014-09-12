/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

@class PHBridgeResource;

typedef enum {
    OPERATOR_EQ = 0, // Equal: Value should be numeric or a boolean stored in a NSNumber or
                     // If the address is /config/localtime, the value should be a NSTimeInterval
    OPERATOR_GT,     // Greater then; value should contain an NSNumber
    OPERATOR_LT,     // Less then; value should contain an NSNumber
    OPERATOR_DX,     // Value changed: value should be empty
                     // Not allowed for the addresses /config/UTC  and /config/localtime
    OPERATOR_DDX,    // Value changed after time interval: value should be NSTimeInterval
                     // Not allowed for the addresses /config/UTC  and /config/localtime
    OPERATOR_DT,     // Time delta : value should be NSTimeInterval.
                     // Not allowed for the addresses /config/UTC  and /config/localtime
    OPERATOR_UNKNOWN = NSNotFound
} PHRuleConditionOperator;

@interface PHRuleCondition : PHBridgeResource<NSCoding, NSCopying>

/**
 local address:
 path to a light resource, a group resource, or any other bridge resource
 
 web address:
 URL of the Portal, an intranet server for a RESTful call using the given method to send the given body.
 The server address http://www.meethue.com/ addresses the Hue portal.
 Examples
 http://www.meethue.com/api/events
 http://192.168.168.1/api/sendtodropbox
 The rule is deactivated if the server does not respond (error code 7). The lost connection of http://www.meethue.com does not cause deactivation.
 */
@property (nonatomic, strong) NSString *address;

/**
 The string value for the address
 */
@property (nonatomic, strong) NSString *valueString;

/**
 The operator for the conditon
 See the enum for which operators are supported
 */
@property (nonatomic, assign) PHRuleConditionOperator operator;

/**
 Initialize the rule condition
 @param address The address to the bridge resource attribute
 @param valueString String value of the attribute
 @param operator The operator to use on the attribute
 */
- (id)initWithAddress:(NSString *)address andValueString:(NSString *)valueString andOperator:(PHRuleConditionOperator)operator;

@end
