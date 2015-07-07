/*******************************************************************************
Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@class PHBridgeConfiguration;
@class PHError;

/**
	Contains the object graph of lights, groups, schedules, and bridge configuration. This is used to store the 
    the current state of the bridge in object form
 */
@interface PHBridgeResourcesCache : NSObject <NSCoding>

@property (atomic, strong) NSDictionary *lights;
@property (atomic, strong) NSDictionary *groups;
@property (atomic, strong) NSDictionary *schedules;
@property (atomic, strong) NSDictionary *scenes;
@property (atomic, strong) NSDictionary *sensors;
@property (atomic, strong) NSDictionary *rules;

@property (atomic, strong) PHBridgeConfiguration *bridgeConfiguration;

/**
	Checks all cointained light, group, sensors and schedule objects are valid objects by calling isValid on each one. Returns NO if any are invalid, and optionally fills the PHError object with error information
	@returns YES if valid NO if not
 */
-(BOOL)isValid;

@end
