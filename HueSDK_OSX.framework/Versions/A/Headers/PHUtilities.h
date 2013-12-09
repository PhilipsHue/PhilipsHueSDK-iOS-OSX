/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

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
 Get's the computername for the whitelist. This method will return the same computername for every application
 on the same device.
 @returns the name to use for pushlinking
 */
+ (NSString *)whitelistName;

/**
 Generates the color for the given XY values.
 Note: When the exact values cannot be represented, it will return the closest match.
 @param xy the xy point of the color
 @param model of the lamp, example: "LCT001" for hue bulb. Used to calculate the color gamut. If this value is empty the default gamut values are used.
 @returns The color
 */
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (UIColor *)colorFromXY:(CGPoint)xy forModel:(NSString*)model;
#else
+ (NSColor *)colorFromXY:(CGPoint)xy forModel:(NSString*)model;
#endif

/**
 Generates a point with x an y value that represents the given color
 @param color the color to convert
 @param model the lamp  model
 @return The xy color
 */
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
+ (CGPoint)calculateXY:(UIColor *)color forModel:(NSString*)model;
#else
+ (CGPoint)calculateXY:(NSColor *)color forModel:(NSString*)model;
#endif

@end
