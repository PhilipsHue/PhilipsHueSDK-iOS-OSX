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

/*
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
 @returns YES when a local heartbeat to a bridge is configured
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
 Use this method to set the minimal bridge connection options to use for the SDK. This method has to be used in combination with a heartbeat as any remaing bridge connection settings will be fetched from the bridge during the first heartbeat. In addition the PHBridgeSendAPI can be used only after the first hearbeat has been successfully processed (after LOCAL_CONNECTION_NOTIFICATION).
 @param ipAddress The IP address of the bridge
 @param bridgeId The identifier of the bridge
 */
- (void)setBridgeToUseWithId:(NSString *)bridgeId ipAddress:(NSString *)ipAddress;

/**
 Use this method to set the full set of bridge connection options to use for the SDK.
 When using this method the PHBridgeSendAPI can be used directly (useful for short living applications).
 @param ipAddress The IP address of the bridge
 @param bridgeId The identifier of the bridge
 @param userName The userName of the bridge
 @param softwareVersion The softwareVersion of the bridge
 @param apiVersion The apiVersion of the bridge
 */
- (void)setBridgeToUseWithId:(NSString*)bridgeId ipAddress:(NSString *)ipAddress userName:(NSString*)userName softwareVersion:(NSString*)softwareVersion apiVersion:(NSString*)apiVersion;

/**
 Returns whether the SDK has an active (heartbeat) connection to the bridge using local network.
 @returns YES when last heartbeat to the bridge was successful, return NO if not successful or when no heartbeat is running
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