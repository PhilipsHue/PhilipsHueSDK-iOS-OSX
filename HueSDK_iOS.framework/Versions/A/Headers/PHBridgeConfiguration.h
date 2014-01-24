/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@class PHBridgeResource;
@class PHSoftwareUpdateStatus;

/**
 Contains the configuration data of the bridge
 */
@interface PHBridgeConfiguration : NSObject<NSCopying>
/**
 The IP address of this bridge
 */
@property (nonatomic, strong) NSString *ipaddress;

/**
 The MAC address of this bridge
 */
@property (nonatomic, strong) NSString *mac;

/**
 The id of this bridge
 */
@property (nonatomic, strong) NSString *bridgeId;

/**
 The username of this bridge
 */
@property (nonatomic, strong) NSString *username;

/**
 The current software version of this bridge
 */
@property (nonatomic, strong) NSString *swversion;

/**
 The current name of the bridge
 */
@property (nonatomic, strong) NSString *name;

/**
 The proxy state of the bridge
 */
@property (nonatomic, readonly) BOOL proxy;

/**
 The current proxy address of the bridge
 */
@property (nonatomic, strong) NSString *proxyAddress;

/**
 The current proxy port of the bridge
 */
@property (nonatomic, strong) NSNumber *proxyPort;

/**
 A dictionary with values about available software updates
 */
@property (nonatomic, strong) PHSoftwareUpdateStatus *softwareUpdate;

/**
 The current netmask address of the bridge 
 */
@property (nonatomic, strong) NSString *netmask;

/**
 The current gateway address of the bridge 
 */
@property (nonatomic, strong) NSString *gateway;

/**
 The current dhcp state of the bridge
 */
@property (nonatomic, strong) NSNumber *dhcp;

/**
 Portal services state of the bridge
 */
@property(nonatomic, strong) NSNumber *portalServices;

/**
 The date/time setting of the bridge
 */
@property (nonatomic, strong) NSString *time;

/**
 Converts the bridge time string to an NSDate
 @returns The date/time setting of the bridge converted to an NSDate
 */
- (NSDate *)getBridgeTimeAsNSDate;

/**
 Converts the bridge configuration to a NSDictionary
 @returns The configuration of the bridge to a NSDictionary
 */
- (NSDictionary *)bridgeConfigurationAsDictionary;

@end
