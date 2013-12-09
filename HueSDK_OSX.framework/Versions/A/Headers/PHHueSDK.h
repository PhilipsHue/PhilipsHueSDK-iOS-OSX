/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

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
- (void)enableLocalConnectionUsingInterval:(NSInteger)interval;

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
 Does the pushlink authentication
 */
- (void)startPushlinkAuthentication;

/**
	Use this method to set the bridge to use for the SDK
	@param ipaddress The ipaddress of the bridge
	@param macaddress The macaddress of the bridge
    @param username The username of the bridge
 */
- (void)setBridgeToUseWithIpAddress:(NSString *)ipaddress macAddress:(NSString *)macaddress andUsername:(NSString *)username __attribute((deprecated("Use 'setBridgeToUseWithIpAddress:macAddress' method as replacement")));;

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

@end
