/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
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

@property (nonatomic, strong) NSDictionary *lights;
@property (nonatomic, strong) NSDictionary *groups;
@property (nonatomic, strong) NSDictionary *schedules;
@property (nonatomic, strong) NSDictionary *scenes;
@property (nonatomic, strong) PHBridgeConfiguration *bridgeConfiguration;

/**
	Checks all cointained light, group and shedule objects are valid objects by calling isValid on each one. Returns NO if any are invalid, and optionally fills the PHError object with error information
	@param nsErrorPtr pointer to an PHError objet
	@returns YES if valid NO if not
 */
-(BOOL)isValid:(PHError **)nsErrorPtr;

@end
