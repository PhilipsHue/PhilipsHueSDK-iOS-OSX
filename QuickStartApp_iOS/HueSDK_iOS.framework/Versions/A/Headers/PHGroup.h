/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

/**
 A grouped set of lights
 */
@interface PHGroup : PHBridgeResource<NSCoding, NSCopying>

/**
 The identifiers of the lights controlled by this group
 */
@property (nonatomic, strong) NSArray *lightIdentifiers;

@end