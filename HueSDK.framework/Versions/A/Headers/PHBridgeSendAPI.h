//
//  PHBridgeSendAPI.h
//  HueSDK v1.0 beta
//
//  Copyright (c) 2012-2013 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHError;
@class PHLightState;
@class PHBridgeConfiguration;
@class PHLight;
@class PHGroup;
@class PHSchedule;
@class PHSoftwareUpdateStatus;

/**
 This is a typedef for a block type. It takes an array of PHErrors.
 */
typedef void (^PHBridgeSendErrorArrayCompletionHandler)(NSArray *errors);

/**
 This is a typedef for a block type. It takes an NSDictionary and an array of PHErrors.
 */
typedef void (^PHBridgeSendDictionaryCompletionHandler)(NSDictionary *dictionary, NSArray *errors);

/*
 This is a typedef for a block type. It takes an NSArray and an array of PHErrors.
 */
typedef void (^PHBridgeSendArrayCompletionHandler)(NSArray *array, NSArray *errors);

/**
 This is a typedef for a block type. It takes an PHLight and an array of PHErrors.
 */
typedef void (^PHBridgeSendLightCompletionHandler)(NSString *lightIdentifier, NSArray *errors);

/**
 This is a typedef for a block type. It takes an PHGroup and an array of PHErrors.
 */
typedef void (^PHBridgeSendGroupCompletionHandler)(NSString *groupIdentifier, NSArray *errors);

/**
 This is a typedef for a block type. It takes an PHSchedule and an array of PHErrors.
 */
typedef void (^PHBridgeSendScheduleCompletionHandler)(NSString *scheduleIdentifier, NSArray *errors);

/**
 This is a typedef for a block type. It takes an PHSoftwareUpdateStatus and an array of PHErrors.
 */
typedef void (^PHBridgeSendSoftwareUpdateStatusCompletionHandler)(PHSoftwareUpdateStatus *softwareUpdateStatus, NSArray *errors);

/**
 This API contain a set of method calls that operate asynchronously. The calls are made to the bridge to set or get data.
 Each method then returns immediately.
 The set or get of data is carried out on another thread and returned to the calling app by updating the BridgeResourcesCache.
 The BridgeResourceCache object data is updated on each SDK heartbeat.
 */
@protocol PHBridgeSendAPI <NSObject>

@required

/**
 Starts a search for new lights
 @param completionHandler completionHandler for error handling 
 */
-(void)searchForNewLights:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;;

/**
 Updates the light properties
 @param light the details of the light to be updated
 @param completionHandler completionHandler for error handling
 */
-(void)updateLightWithLight:(PHLight *)light completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Updates the state settings of the light
 @param lightIdentifier the identifier of the light to be updated
 @param lightState the lightstate settings for to set the light to
 @param completionHandler completionHandler for error handling
 */
-(void)updateLightStateForId:(NSString *)lightIdentifier withLighState:(PHLightState *)lightState  completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Updates the bridge configuration
 @param bridgeConfiguration the new configuration for the bridge
 @param completionHandler completionHandler for error handling
 */
- (void)updateConfigurationWithConfiguration:(PHBridgeConfiguration *)bridgeConfiguration completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Removes a username from the white list entries in the bridge
 @param username the username to be removed from the bridge
 @param completionHandler completionHandler for error handling
 */
- (void)removeWhitelistEntryWithUsername:(NSString *)username completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Get newly found lights since last search for new lights
 @param completionHandler completionHandler for returning this lights found and error handling
 */
-(void)getNewFoundLights:(PHBridgeSendDictionaryCompletionHandler)completionHandler;

/**
 Creates a new Group of lights
 @param name the name of the group
 @param lightIds the array of light ids to group
 @param completionHandler completionHandler for details of created group or error handling
 */
-(void)createGroupWithName:(NSString *)name lightIds:(NSArray *)lightIds completionHandler:(PHBridgeSendGroupCompletionHandler)completionHandler
;

/**
 Update a given Group of lights
 @param group the details of the group to update
 @param completionHandler completionHandler for error handling
 */
-(void)updateGroupWithGroup:(PHGroup *)group completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Remote the group with the given identifier
 @param groupIdentifier the identifier of the group to remove
 @param completionHandler completionHandler for error handling
 */
-(void)removeGroupWithId:(NSString *)groupIdentifier completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Performs the action for the specified group
 @param groupIdentifier The group indentifier for the action
 @param lightState the lightState to set the group to
 @param completionHandler completionHandler for error handling
 */
- (void)setLightStateForGroupWithId:(NSString *)groupIdentifier lightState:(PHLightState *)lightState completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Creates a new schedule
 @param schedule the details of the schedule
 @param completionHandler completionHandler for details of schedule created or error handling
 */
-(void)createSchedule:(PHSchedule *)schedule completionHandler:(PHBridgeSendScheduleCompletionHandler)completionHandler;

/**
 Remove the schedule with the given identifier
 @param scheduleIdentifier the identifier of the schedule to remove
 @param completionHandler completionHandler for error handling
 */
-(void)removeScheduleWithId:(NSString *)scheduleIdentifier completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Updates the schedule information
 @param schedule the schedule to be updated
 @param completionHandler completionHandler for error handling
 */
-(void)updateScheduleWithSchedule:(PHSchedule *)schedule completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

#pragma mark - Software update

/**
 Starts the software update process.
 @param completionHandler completionHandler for error handling
 */
- (void)softwareUpdateStart:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Removes the notification which is set when a software update was finished.
 @param completionHandler completionHandler for error handling
 */
- (void)softwareUpdateRemoveNotify:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Gets the current software update status from the bridge.
 @param completionHandler completionHandler for returning the current status and error handling
 */
- (void)getSoftwareUpdateStatus:(PHBridgeSendSoftwareUpdateStatusCompletionHandler)completionHandler;

/**
 This method lets you disable updates of the cache right after a success message is received by this instance of the bridgeSendAPI.
 By default the automatic cache update is enabled.
 @param enabled YES to enable cache update, NO to disable.
 */
- (void)setCacheUpdateAfterSuccessResponseEnabled:(BOOL)enabled;

@end