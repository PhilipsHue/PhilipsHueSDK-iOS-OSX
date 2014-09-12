/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@interface PHSwitchButtonInfo : NSObject <NSCoding, NSCopying>

/**
 
 */
@property (nonatomic, strong) NSString *buttonId;

/**
 
 */
@property (nonatomic, strong) NSNumber *channel;

/**
 
 */
@property (nonatomic, strong) NSString *buttonImageName;

/**
 
 */
@property (nonatomic, assign) CGRect buttonPosition;

@end
