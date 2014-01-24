/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

/**
 A grouped set of lights
 */
@interface PHGroup : PHBridgeResource<NSCopying>

/**
 The identifiers of the lights controlled by this group
 */
@property (nonatomic, strong) NSArray *lightIdentifiers;
/**
 returns dictionary of group details
 @returns dictionary of group details
 */
- (NSDictionary *) getGroupAsDictionary;


@end