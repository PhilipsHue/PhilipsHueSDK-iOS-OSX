/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHBridgeResource.h"

#define WHITELIST_DELIMITER '#'

@interface PHWhitelistEntry : PHBridgeResource

/**
 The username used for authentication with the bridge
 */
@property (nonatomic, strong) NSString *username;

/**
 The name of the app
 Max 20 bytes
 */
@property (nonatomic, strong) NSString *appName;

/**
 The name of the device
 Max 19 bytes
 Only alphanumeric characters allowed
 */
@property (nonatomic, strong) NSString *deviceName;

/**
 The date when the entry is used for the last time
 */
@property (nonatomic, strong) NSDate *lastUsed;

/**
 Creation date of the entry
 */
@property (nonatomic, strong) NSDate *created;

@end