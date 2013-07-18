/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

/**
 A grouped set of lights
 */
@interface PHScene : PHBridgeResource

/**
 The identifiers of the lights controlled by this scene
 */
@property (nonatomic, strong) NSArray *lightIdentifiers;
/**
 returns dictionary of scene details
 @returns dictionary of scene details
 */
- (NSDictionary *) getSceneAsDictionary;


@end