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
 List of IDs of mains powered lights to be updated.
 */
@property (nonatomic, strong) NSArray *mainsLights;

/**
 List of IDs of battery powered lights to be updated
 */
@property (nonatomic, strong) NSArray *batteryLights;

/**
 List of IDs of mains powered sensors to be updated
 */
@property (nonatomic, strong) NSArray *mainsSensors;

/**
 List of IDs of battery powered sensors to be updated
 */
@property (nonatomic, strong) NSArray *batterySensors;

/**
 List of IDs of deep-sleep battery powered sensors to be updated.
 */
@property (nonatomic, strong) NSArray *slowSensors;

@end
