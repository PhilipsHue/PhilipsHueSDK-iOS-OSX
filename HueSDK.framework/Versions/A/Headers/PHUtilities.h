/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>

/**
 This class contains some utilities for applications using the HueSDK.
 */
@interface PHUtilities : NSObject

/**
 Creates a username for the whitelist. This method will return the same username for every application
 on the same device. The advantage of this is that the user will only have to pushlink each device once instead
 of for every application using hue.
 @returns the identifier to use for pushlinking
 */
+ (NSString *)whitelistIdentifier;

/**
 Generates the color for the given XY values.
 Note: When the exact values cannot be represented, it will return the closest match.
 @param xy the xy point of the color
 @param brightness the brightness for the color (between 0.0 - 1.0)
 @param model of the lamp, example: "LCT001" for hue bulb. Used to calculate the color gamut. If this value is empty the default gamut values are used.
 @returns The color
 */
+ (UIColor *)colorFromXY:(CGPoint)xy andBrightness:(float)brightness forModel:(NSString*)model;

/**
 Generates a point with x an y value that represents the given color
 @param xy pointer to a CGPoint which will be set to the xy values for the given color
 @param brightness pointer to a float which will be set to the brightness for the given color
 @param color the color to convert
 @param model the lamp  model
 */
+ (void)calculateXY:(CGPoint *)xy andBrightness:(float *)brightness fromColor:(UIColor *)color forModel:(NSString*)model;

@end
