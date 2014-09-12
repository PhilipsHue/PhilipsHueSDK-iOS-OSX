/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSwitchButtonInfo.h"

@interface PHSwitchDeviceInfo : NSObject <NSCoding, NSCopying>

/**
 
 */
@property (nonatomic, strong) NSString *modelId;

/**
 
 */
@property (nonatomic, strong) NSString *modelName;

/**
 
 */
@property (nonatomic, strong) NSString *manufacturerName;

/**
 
 */
@property (nonatomic, strong) NSArray *sourceIdRanges;

/**
 
 */
@property (nonatomic, strong) NSArray *buttons;

/**
 
 */
@property (nonatomic, strong) NSDictionary *eventButtonMapping;

/**
 
 */
@property (nonatomic, strong) NSString *housingImageName;

@end