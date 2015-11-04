/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

typedef enum {
    GROUP_TYPE_UNKNOWN,
    GROUP_TYPE_LUMINAIRE,
    GROUP_TYPE_LIGHTGROUP,
    GROUP_TYPE_LIGHTSOURCE
} PHGroupType;

/**
 A grouped set of lights
 */
@interface PHGroup : PHBridgeResource<NSCoding, NSCopying>

/**
 The identifiers of the lights controlled by this group
 */
@property (nonatomic, strong) NSArray *lightIdentifiers;

/**
 The type of this group
 */
@property (nonatomic, assign) PHGroupType type;

/**
 This model ID uniquely identifies the hardware model of the luminaire for the given manufacturer. Only present for automatically created Luminaires,
 */
@property (nonatomic, strong) NSString *modelID;

/**
 This unique id of the luminaire. This field is only set on a group of type GROUP_TYPE_LUMINAIRE and GROUP_TYPE_LIGHT_SOURCE
 */
@property (nonatomic, strong) NSString *uniqueId;

- (BOOL)isComplete;

@end