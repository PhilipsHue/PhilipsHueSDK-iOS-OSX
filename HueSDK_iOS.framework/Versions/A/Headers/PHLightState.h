/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    COLORMODE_UNKNOWN, // It is unknown what the current colormode is
    COLORMODE_NONE, // No colormode (for lights which do not support color)
    COLORMODE_CT, // Color is set by ct
    COLORMODE_HUE_SATURATION, // Color is set by hue + saturation
    COLORMODE_XY // Color is set by xy
} PHLightColormode;

typedef enum {
    ALERT_UNKNOWN, // It is unkown what the current alert value is
    ALERT_NONE, // No alert active
    ALERT_SELECT, // Select alert (1 breath cycle) is active
    ALERT_LSELECT // Select alert (30 seconds of breath cycles) is active
} PHLightAlertMode;

typedef enum {
    EFFECT_UNKNOWN, // It is unknown what the current effect value is
    EFFECT_NONE, // No effect active
    EFFECT_COLORLOOP // Colorloop effect (loop through colors whith current saturation and brightness)
} PHLightEffectMode;

/**
 The state settings of a light, that can be applied to a light, group of lights,
 or for a scheduled change
 */
@interface PHLightState : NSObject<NSCopying>

/**
 Returns an NSDictionary containing the property values of this PHLightState
 @returns the Light State dictionary
 */
-(NSDictionary *)getLightStateAsDictionary;

/**
 The on off status to set the light to.
 YES means on, NO means off.
 */
@property (nonatomic, strong) NSNumber *on;

/**
 The brightness to set the light to.
 Range: 0 (lowest brightness, but not off) to 254 (highest brightness).
 */
@property (nonatomic, strong) NSNumber *brightness;

/**
 The hue to set the light to, representing a color.
 Range: 0 - 65535 (which represents 0-360 degrees)
 Explanation: http://en.wikipedia.org/wiki/Hue
 */
@property (nonatomic, strong) NSNumber *hue;

/**
 The saturation to set the light to.
 Range: 0 (least saturated, white) - 254 (most saturated, vivid).
 */
@property (nonatomic, strong) NSNumber *saturation;

/**
 The colortemperature to set the light to in Mirek
 Range of 2012 hue bulb: 153 (coldest white) - 500 (warmest white)
 Explanation: http://en.wikipedia.org/wiki/Mired
 */
@property (nonatomic, strong) NSNumber *ct;

/**
 x value of a color represented by the CIE 1931 color space
 Range: 0.0 - 1.0
 Explanation: http://en.wikipedia.org/wiki/CIE_1931_color_space
 */
@property (nonatomic, strong) NSNumber *x;

/**
 y value of a color represented by the CIE 1931 color space
 Range: 0.0 - 1.0
 Explanation: http://en.wikipedia.org/wiki/CIE_1931_color_space
 */
@property (nonatomic, strong) NSNumber *y;

/**
 The alert to set the light to.
 Options: "none" (no alert), "select" (1 breath cycle), "lselect" (breathes for 30 seconds or until value none is set)
 */
@property (nonatomic, assign) PHLightAlertMode alert;

/**
 The effect to set the light to
 Options: "none" (no effect), "colorloop" (starts a colorloop with the current saturation and brightness until value none is set)
 */
@property (nonatomic, assign) PHLightEffectMode effect;

/**
 Colormode of this light.
 Readonly value.
 Values: 
 - "HS": color is set by hue + saturation
 - "CT": color is set by ct value
 - "XY": color is set by xy values
 */
@property (nonatomic, assign) PHLightColormode colormode;

/**
 The transition to take to go to this state in 100ms
 So 1 means 100ms, 10 means 1 second.
 Range: 0 (instant) - 65535 (longest fade)
 */
@property (nonatomic, strong) NSNumber *transitionTime;

/**
 Property indicating if the bridge can reach this light
 Readonly value.
 */
@property (nonatomic, strong) NSNumber *reachable;

/**
 Sets the on off status of this light
 @param on Boolean value indicating the on off status of the light
 */
- (void)setOnBool:(BOOL)on;

/**
 Validate the light state by checking if the values of the properties are in range
 @param Array with PHError objects if one or more errors occured. nil if no errors occured
 */
- (NSArray *)validateLightState;

@end
