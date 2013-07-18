/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

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
