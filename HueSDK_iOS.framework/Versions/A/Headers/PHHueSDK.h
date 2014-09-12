/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHHeartbeatBridgeResourceType.h"

@class PHHeartbeat;
@class PHError;
@class PHBridgeConfiguration;
@class PHAuthentication;
@class PHNotificationManager;

/**
 This is the main class for the app to use the SDK. From this class heartbeats can be started and stopped
 and the bridge searching process can be initiated.
 */
@interface PHHueSDK : NSObject

/**
 The heartbeat class to use for the heartbeats
 */
@property (nonatomic, strong) PHHeartbeat *phHeartbeat;

/**
 The authentication class to use for authentication
 */
@property (nonatomic, strong) PHAuthentication *phAuthentication;

/**
 The notification manager used for sending notifications
 */
@property (nonatomic, strong) PHNotificationManager *notificationManager;

/**
 Indicated whether the first local heartbeat processing has completed after starting the local heartbeat.
 This will be reset after every stop and start of the heartbeat.
 */
@property (nonatomic, assign) BOOL firstLocalHeartbeatCompletedAfterStart;

/**
 Starts the SDK
 @returns error when SDK failed to start, nil when started without error
 */
- (void)startUpSDK;

/**
 Stops the SDK
 */
- (void)stopSDK;

/**
 Enables local connections to the bridge
 @param interval The interval at which to poll the bridge for a local connection.
 */
- (void)enableLocalConnectionUsingInterval:(NSInteger)interval __attribute((deprecated("Instead use setLocalInterval:ForResourceType: to set intervals for all or selected bridge resources and enableLocalConnection to start the local connection.")));

/**
 Disables local connections to the bridge
 */
- (void)disableLocalConnection;

/**
 Returns whether this instance of the SDK tries to connect to a bridge locally.
 @returns YES when local connections are enabled, NO otherwise.
 */
- (BOOL)connectsLocal;

/**
 Does the pushlink authentication process
 */
- (void)startPushlinkAuthentication;

/**
 Cancels the pushlink authentication process
 */
- (void)cancelPushLinkAuthentication;

/**
 Use this method to set the bridge to use for the SDK
 @param ipaddress The ipaddress of the bridge
 @param macaddress The macaddress of the bridge
 */
- (void)setBridgeToUseWithIpAddress:(NSString *)ipaddress macAddress:(NSString *)macaddress;

/**
 Returns whether the SDK has an active connection to the bridge using local network.
 @returns YES when connected to the bridge, no otherwise
 */
- (BOOL)localConnected;

/**
 Disables the cache update for the local heartbeat.
 @param disableCacheUpdate When YES, the cache is not updated, otherwise it is.
 */
- (void)disableCacheUpdateLocalHeartbeat:(BOOL)disableCacheUpdate;

/**
 Enables the logging
 @param enableLogging When YES, the logging is enabled, otherwise disabled.
 */
- (void)enableLogging:(BOOL)enableLogging;

/**
 Enables local connections to the bridge and starts the configured heartbeats
 */
- (void)enableLocalConnection;

/**
 Sets the local heartbeat for a resource type
 @param heartbeatIntervalLocal The interval (valid values 0.25 - 300, values will be rounded down to the nearest quarter)
 @param resourceType The resource type for wich the heartbeat should be set
 */
- (void)setLocalHeartbeatInterval:(float)heartbeatIntervalLocal forResourceType:(PHHeartbeatBridgeResourceType)resourceType;

/**
 Removes the local heartbeat for a resource type
 @param resourceType The resource type for wich the heartbeat should be revmoed
 */
- (void)removeLocalHeartbeatForResourceType:(PHHeartbeatBridgeResourceType)resourceType;

/**
 Get the local heartbeat interval that is set for a resource type
 @param resourceType The resource type for wich the heartbeat should be retrieved
 @returns interval of resource type heartbeat, when not set returns 0
 */
- (float)getLocalHeartbeatIntervalForResourceType:(PHHeartbeatBridgeResourceType)resourceType;

@end