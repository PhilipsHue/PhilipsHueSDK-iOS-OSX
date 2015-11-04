/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

@class PHWhitelistEntry;
@class PHSoftwareUpdateStatus;
@class PHPortalState;
@class PHBackup;

/**
 Contains the configuration data of the bridge
 */
@interface PHBridgeConfiguration : PHBridgeResource<NSCoding, NSCopying>

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
 The model id of this bridge
 */
@property (nonatomic, strong) NSString *modelId;

/**
 The username used for authentication with the bridge
 */
@property (nonatomic, strong) NSString *username;

/**
 The whitelist entries maintained in the bridge
 */
@property (nonatomic, strong) NSArray *whitelistEntries;

/**
 The application name in this bridge
 */
@property (nonatomic, strong) NSString *applicationName;

/**
 The current software version of this bridge
 */
@property (nonatomic, strong) NSString *apiversion;

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
 The date/time setting of the bridge (UTC)
 */
@property (nonatomic, strong) NSString *time;

/**
 The date/time setting of the bridge (Local time)
 */
@property (nonatomic, strong) NSString *localTime;

/**
 The date/time setting of the bridge
 */
@property (nonatomic, strong) NSTimeZone *timeZone;

/**
 Zigbee channel of the bridge
 */
@property (nonatomic, strong) NSNumber *channel;

/**
 Portal state of the bridge
 */
@property (nonatomic, strong) PHPortalState *portalState;

/**
 Reboot flag of the bridge
 */
@property (nonatomic, strong) NSNumber *reboot;

/**
 Indicates if bridge settings are factory new
 */
@property (nonatomic, strong) NSNumber *factoryNew;

/**
 If a bridge backupfile has been restored on
 this bridge stemming from a bridge with a
 different bridgeid, it will indicate that bridge id
 */
@property (nonatomic, strong) NSString *replacesBridgeId;

/**
 Backup state
 */
@property (nonatomic, strong) PHBackup *backup;

/**
 Converts the bridge time string to an NSDate
 @returns The date/time setting of the bridge converted to an NSDate
 */
- (NSDate *)getBridgeTimeAsNSDate;

/**
 Converts the bridge local time string to an NSDate
 @returns The date/time setting of the bridge converted to an NSDate
 */
- (NSDate *)getBridgeLocalTimeAsNSDate;

/**
 Get the whitelist entry by username
 */
- (PHWhitelistEntry *)whitelistEntryByUsername:(NSString *)username;

@end