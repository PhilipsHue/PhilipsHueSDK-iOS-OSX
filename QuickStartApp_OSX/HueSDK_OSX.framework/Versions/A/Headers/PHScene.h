/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

typedef enum {
    SCENE_STATE_UNKNOWN, // It is unkown what the current scene state is
    SCENE_STATE_INACTIVE, // Scene inactive
    SCENE_STATE_ACTIVE, // Scene active
} PHSceneActiveState;

/**
 A grouped set of lights
 */
@interface PHScene : PHBridgeResource<NSCoding, NSCopying>

/**
 The identifiers of the lights controlled by this scene
 */
@property (nonatomic, strong) NSArray *lightIdentifiers;

/**
 The transition to take to go to this state in 100ms
 So 1 means 100ms, 10 means 1 second.
 Range: 0 (instant) - 65535 (longest fade)
 */
@property (nonatomic, strong) NSNumber *transitionTime;

/**
 Indicates whether this scene is fully created and ready to be used / recalled
 */
@property (nonatomic, assign) PHSceneActiveState active;

@end