/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

@class PHLightState;

@interface PHRuleAction : PHBridgeResource<NSCoding, NSCopying>

/**
 path to an attribute of a sensor resource, light resource, or any other bridge 
 resource (v1.2.1). /api/<username> is omitted
 
 Examples:
 /sensors/<id>/state/presence
 /lights/<id>/state/reachable
 */
@property (nonatomic, strong) NSString *address;

/**
 The HTTP method used to send the body to the given address.
 Either “POST”, “PUT” (optionally more)
 If the method is not supported or not supported by the server for the given address, the rule is deactivated (error code 5)
*/
@property (nonatomic, strong) NSString *method;

/**
 -	JSON string to be send to the local CLIP resource. The rule is deactivated if 
 body is not accepted by the resource. (error code 6)
 -	JSON string to be send to the portal.
 -	A free format string send to an intranet server
 */
@property (nonatomic, strong) id body;

/**
 Initialize the rule action
 @param address The address to the bridge resource (attribute)
 @param valueString String value of the attribute
 @param operator The operator to use on the attribute
 */
- (id)initWithAddress:(NSString *)address andMethod:(NSString *)method andBody:(id)body;

@end
