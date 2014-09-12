/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    #import <UIKit/UIKit.h>
#else
    #import <AppKit/AppKit.h>
#endif

/**
 This class contains some utilities for applications using the HueSDK.
 */
@interface PHUtilities : NSObject

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

/**
 Get a CGPoint from a NSValue object (works on both iOS and OSX)
 @param value with a point
 @return The point from this value
 */
+ (CGPoint)getPointFromValue:(NSValue*)value;

/**
 Get a NSValue from a CGPoint object (works on both iOS and OSX)
 @param point
 @return The value with a point
 */
+ (NSValue*)getValueFromPoint:(CGPoint)point;

/**
 Get a CGRect from a NSValue object (works on both iOS and OSX)
 @param value with a point
 @return The rect from rect value
 */
+ (CGRect)getRectFromValue:(NSValue*)value;

/**
 Get a NSValue from a CGRect object (works on both iOS and OSX)
 @param point
 @return The value with a rect
 */
+ (NSValue*)getValueFromRect:(CGRect)rect;

/**
 Get the knowledge base of supported switches
 */
+ (NSDictionary *)getSwitchKnowledgeBase;

@end