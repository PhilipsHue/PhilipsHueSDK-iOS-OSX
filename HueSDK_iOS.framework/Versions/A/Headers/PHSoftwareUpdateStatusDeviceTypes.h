/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@interface PHSoftwareUpdateStatusDeviceTypes : NSObject <NSCopying,NSCoding>

/**
 Flag for when bridge update is avaliable
 */
@property (nonatomic, strong) NSNumber *bridge;

/**
 List of IDs of lights to be updated.
 */
@property (nonatomic, strong) NSArray *lights;

/**
 List of IDs of sensors to be updated
 */
@property (nonatomic, strong) NSArray *sensors;

@end
