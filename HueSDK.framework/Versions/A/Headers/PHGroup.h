//
//  PHGroup.h
//  HueSDK v1.0 beta
//
//  Copyright (c) 2012-2013 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

/**
 A grouped set of lights
 */
@interface PHGroup : PHBridgeResource

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