//
//  PHBridgeResource.h
//  HueSDK v1.0 beta
//
//  Copyright (c) 2012-2013 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHError;

/**
	Base object for bridge resourcs that have an identifier and name
 */
@interface PHBridgeResource : NSObject <NSCoding>
/**
 The identifier 
 */
@property (nonatomic, strong) NSString *identifier;

/**
 The name 
 */
@property (nonatomic, strong) NSString *name;

- (BOOL)isValid:(PHError **)errPtr;

@end
