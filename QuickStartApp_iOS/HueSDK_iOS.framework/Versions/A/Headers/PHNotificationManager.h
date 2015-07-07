/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

#pragma mark - Connection notifications

/**
 Notification which is send when a local connection to the bridge is made
 */
#define LOCAL_CONNECTION_NOTIFICATION       @"LOCAL_CONNECTION_NOTIFICATION"

/**
 Notification which is send when local connection to bridge is lost
 */
#define NO_LOCAL_CONNECTION_NOTIFICATION    @"NO_LOCAL_CONNECTION_NOTIFICATION"

/**
 Notification which when no local bridge is known
 */
#define NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION  @"NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION"

/**
 Notification which when no local authentication is possible
 */
#define NO_LOCAL_AUTHENTICATION_NOTIFICATION  @"NO_LOCAL_AUTHENTICATION_NOTIFICATION"

/**
 Notification which is send when the data returned by the bridge could not be parsed during a heartbeat
 */
#define HEARTBEAT_PARSE_ERROR_NOTIFICATION  @"HEARTBEAT_PARSE_ERROR_NOTIFICATION"

/**
 Notification which is send when a heartbeat timer event for a resource type is called and the current bridge doesn't support multi resource heartbeat 
 */
#define HEARTBEAT_MULTI_RESOURCE_NOT_SUPPORTED_NOTIFICATION  @"HEARTBEAT_MULTI_RESOURCE_NOT_SUPPORTED_NOTIFICATION"

/**
 Notification which is send when local heartbeat is processed successfully
 */
#define LOCAL_HEARTBEAT_PROCESSING_SUCCESSFUL_NOTIFICATION @"LOCAL_HEARTBEAT_PROCESSING_SUCCESSFUL_NOTIFICATION"

/**
 Notification which is send when portal heartbeat is processed successfully
 */
#define PORTAL_HEARTBEAT_PROCESSING_SUCCESSFUL_NOTIFICATION @"PORTAL_HEARTBEAT_PROCESSING_SUCCESSFUL_NOTIFICATION"

#pragma mark - Pushlink notifications

/**
 Notification which is send when local connection to bridge is lost
 */
#define PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION    @"PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION"

/**
 Notification which when no local bridge is known
 */
#define PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION  @"PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION"

/**
 Notification which is send when the local authentication is failed
 */
#define PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION @"PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION"

/**
 Notification which is send when the button is not pressed yet during authentication
 */
#define PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION @"PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION"

/**
 Notification which is send when the local authentication is successful
 */
#define PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION @"PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION"

#pragma mark - Cache update notifications

/**
 Notification which is send when the lights in the cache have changed
 */
#define LIGHTS_CACHE_UPDATED_NOTIFICATION  @"LIGHTS_CACHE_UPDATED_NOTIFICATION"

/**
 Notification which is send when the groups in the cache have changed
 */
#define GROUPS_CACHE_UPDATED_NOTIFICATION  @"GROUPS_CACHE_UPDATED_NOTIFICATION"

/**
 Notification which is send when the schedules in the cache have changed
 */
#define SCHEDULES_CACHE_UPDATED_NOTIFICATION  @"SCHEDULES_CACHE_UPDATED_NOTIFICATION"

/**
 Notification which is send when the scenes in the cache have changed
 */
#define SCENES_CACHE_UPDATED_NOTIFICATION  @"SCENES_CACHE_UPDATED_NOTIFICATION"

/**
 Notification which is send when the scenes in the cache have changed
 */
#define SENSORS_CACHE_UPDATED_NOTIFICATION  @"SENSOR_CACHE_UPDATED_NOTIFICATION"

/**
 Notification which is send when the rules in the cache have changed
 */
#define RULES_CACHE_UPDATED_NOTIFICATION @"RULES_CACHE_UPDATED_NOTIFICATION"

/**
 Notification which is send when the bridge configuration in the cache is changed
 */
#define BRIDGE_CONFIGURATION_CACHE_UPDATED_NOTIFICATION  @"BRIDGE_CONFIGURATION_CACHE_UPDATED_NOTIFICATION"

/**
	Notification manager used by the SDK to send notifications to the application using the SDK.
 */
@interface PHNotificationManager : NSObject

/**
 Returns the default SDK notification manager
 @return the notification manager
 */
+ (PHNotificationManager *)defaultManager;

/**
 Registers an object for notification
 @param object the object
 @param selector the selector to invoke on the object upon notification
 @param notification the notification
 @return YES when registering was successful, NO otherwise
 */
- (BOOL)registerObject:(id)object withSelector:(SEL)selector forNotification:(NSString *)notification;

/**
 Deregisters an object for a certain notification
 @param object the object
 @param notification the notification
 @return YES when deregistering was successful, NO otherwise
 */
- (BOOL)deregisterObject:(id)object forNotification:(NSString *)notification;

/**
 Deregisters an object for all notifications
 @param object the Object
 */
- (void)deregisterObjectForAllNotifications:(id)object;

/**
 Sends notification to all objects registered for the notification.
 @param notification the notification
 @return YES when notification is send, NO otherwise
 */
- (BOOL)sendNotification:(NSString *)notification;

/**
 Sends notification to all objects registered for the notification.
 @param notification the notification
 @param userInfo dictionary to send with the notification with additional information
 @return YES when notification is send, NO otherwise
 */
- (BOOL)sendNotification:(NSString *)notification withUserInfo:(NSDictionary *)userInfo;

@end
