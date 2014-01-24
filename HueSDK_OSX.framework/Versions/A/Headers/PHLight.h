/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

@class PHLightState;

/**
 A light and its settings
 */
@interface PHLight : PHBridgeResource<NSCopying>

/**
 Supported types of lights
 */
typedef enum {
    UNKNOWN_LIGHT,
    CT_COLOR_LIGHT,
    CT_LIGHT,
    COLOR_LIGHT,
    DIM_LIGHT,
    ON_OFF_LIGHT
} PHLightType;

@property (nonatomic, assign) BOOL reachable;
@property (nonatomic, assign) PHLightType type;
@property (nonatomic, strong) PHLightState *lightState;
@property (nonatomic, strong) NSString *versionNumber;
@property (nonatomic, strong) NSString *modelNumber;

/**
 Sets the type of the light by the natural string from the bridge.
 */
- (void)setTypeByString:(NSString *)typeString;

/**
 Returns whether the light supports color (hue/saturation) values
 @returns YES when color is supported, NO otherwise
 */
- (BOOL)supportsColor;

/**
 Returns whether the light supports color temperature (CT) values
 @returns YES when CT is supported, NO otherwise
 */
- (BOOL)supportsCT;

/**
 Returns whether the light supports brightness values
 @returns YES when brightness is supported, NO otherwise
 */
- (BOOL)supportsBrightness;

/**
 Returns a dictionary containing the details of this light.
 @returns the dictionary of light details
 */
- (NSDictionary *) getLightAsDictionary;


@end