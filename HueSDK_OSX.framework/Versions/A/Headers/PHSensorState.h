/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

@interface PHSensorState : PHBridgeResource<NSCoding, NSCopying>

/**
 The date of when sensor was last updated.
 
 Readonly
 */
@property (nonatomic, strong) NSDate *lastUpdated;

@end
