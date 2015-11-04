/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@class PHError;
@class PHLightState;
@class PHBridgeConfiguration;
@class PHLight;
@class PHLightConfig;
@class PHLightStartupState;
@class PHGroup;
@class PHSchedule;
@class PHSoftwareUpdateStatus;
@class PHScene;
@class PHSensor;
@class PHSensorState;
@class PHSensorConfig;
@class PHRule;
@class PHRequest;

@protocol PHSearchForNewDevicesDelegate <NSObject>

- (void)searchStarted;
- (void)searchFailed:(NSArray*)errors;
- (void)searchFinished;

@end

/**
 This is a typedef for a block type. It takes an array of PHErrors.
 */
typedef void (^PHBridgeSendErrorArrayCompletionHandler)(NSArray *errors);

/**
 This is a typedef for a block type. It takes an NSDictionary and an array of PHErrors.
 */
typedef void (^PHBridgeSendDictionaryCompletionHandler)(NSDictionary *dictionary, NSArray *errors);

/**
 This is a typedef for a block type. It takes an NSDictionary, a string (this can be "never", "active" or a string representation of the UTC date of the last search and an array of PHErrors.
 */
typedef void (^PHBridgeSendGetNewDevicesCompletionHandler)(NSDictionary *dictionary, NSString *lastScan, NSArray *errors);

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
 This is a typedef for a block type. It takes an sensor identifier and an array of PHErrors.
 */
typedef void (^PHBridgeSendSensorCompletionHandler)(NSString *sensorIdentifier, NSArray *errors);

/**
 This is a typedef for a block type. It takes an rule identifier and an array of PHErrors.
 */
typedef void (^PHBridgeSendRuleCompletionHandler)(NSString *ruleIdentifier, NSArray *errors);

/**
 This is a typedef for a block type. It takes an array of time zones and an array of PHErrors.
 */
typedef void (^PHBridgeSendGetTimeZonesCompletionHandler)(NSArray *timeZones, NSArray *errors);

@interface PHBridgeSendAPI : NSObject

- (void)setCacheUpdateAfterSuccessResponseEnabled:(BOOL)enabled;

#pragma mark - Timezones

/**
 Get the time zones which are supported by the bridge
 @param completionHandler completionHandler for returning the time zones and error handling
 */
- (PHRequest*)getTimeZonesWithCompletionHandler:(PHBridgeSendGetTimeZonesCompletionHandler)completionHandler;

#pragma mark - Luminaires



#pragma mark - Lights

/**
 Starts a search for new lights. This will cancel all other running devices searches (lights or sensors)
 @param delegate A delegate for search status reporting and error handling
 @return the request
 */
- (PHRequest *)searchForNewLightsWithDelegate:(id<PHSearchForNewDevicesDelegate>)delegate;

/**
 Starts a search for new lights using the given serials. This will cancel all other running devices searches (lights or sensors)
 @param serials An array of serials (NSStrings of hex characters), maximum of 10
 @param delegate A delegate for search status reporting and error handling
 @return the request
 */
- (PHRequest *)searchForNewLightsWithSerials:(NSArray *)serials delegate:(id<PHSearchForNewDevicesDelegate>)delegate;

/**
 Cancels search for new devices. Bridge can still continue searching, but polling and status reporting will be stopped.
 */
- (void)cancelSearch;

/**
 Get newly found lights since last search for new lights
 @param completionHandler completionHandler for returning this lights found and error handling
 @return the request
 */
- (PHRequest *)getNewFoundLights:(PHBridgeSendGetNewDevicesCompletionHandler)completionHandler __attribute((deprecated("New found lights will only return the light headers of indiviual lightspoints, for complete resources and luminaire support please use cache together with a heartbeat to see the new found resources.")));

/**
 Updates the light properties
 @param light the details of the light to be updated
 @param completionHandler completionHandler for error handling
 @return the request
 */
- (PHRequest *)updateLightWithLight:(PHLight *)light completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Remove the light with the given identifier
 @param lightIdentifier the identifier of the light to remove
 @param completionHandler completionHandler for error handling
 @return the request
 */
- (PHRequest *)removeLightWithId:(NSString*)lightIdentifier completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Updates the state settings of the light
 @param lightIdentifier the identifier of the light to be updated
 @param lightState the lightstate settings for to set the light to
 @param completionHandler completionHandler for error handling
 @return the request
 */
- (PHRequest *)updateLightStateForId:(NSString *)lightIdentifier withLightState:(PHLightState *)lightState completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

#pragma mark - Bridge configuration

/**
 Updates the bridge configuration
 @param bridgeConfiguration the new configuration for the bridge
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)updateConfigurationWithConfiguration:(PHBridgeConfiguration *)bridgeConfiguration completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Removes a username from the white list entries in the bridge
 @param username the username to be removed from the bridge
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)removeWhitelistEntryWithUsername:(NSString *)username completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

#pragma mark - Groups

/**
 Creates a new Group of lights
 @param name the name of the group
 @param lightIds the array of light ids to group
 @param completionHandler completionHandler for details of created group or error handling
  @return the request
 */
- (PHRequest *)createGroupWithName:(NSString *)name lightIds:(NSArray *)lightIds completionHandler:(PHBridgeSendGroupCompletionHandler)completionHandler
;

/**
 Update a given Group of lights
 @param group the details of the group to update
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)updateGroupWithGroup:(PHGroup *)group completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Remote the group with the given identifier
 @param groupIdentifier the identifier of the group to remove
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)removeGroupWithId:(NSString *)groupIdentifier completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Performs the action for the specified group
 @param groupIdentifier The group indentifier for the action
 @param lightState the lightState to set the group to
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)setLightStateForGroupWithId:(NSString *)groupIdentifier lightState:(PHLightState *)lightState completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

#pragma mark - Schedules

/**
 Creates a new schedule
 @param schedule the details of the schedule
 @param completionHandler completionHandler for details of schedule created or error handling
  @return the request
 */
- (PHRequest *)createSchedule:(PHSchedule *)schedule completionHandler:(PHBridgeSendScheduleCompletionHandler)completionHandler;

/**
 Updates the schedule information
 @param schedule the schedule to be updated
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)updateScheduleWithSchedule:(PHSchedule *)schedule completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Remove the schedule with the given identifier
 @param scheduleIdentifier the identifier of the schedule to remove
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)removeScheduleWithId:(NSString *)scheduleIdentifier completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

#pragma mark - Software update

/**
 Let's the bridge search for software update at the portal. Requires portal connection to update server
 @param completionHandler completionHandler for error handling
 @return the request
 */
- (PHRequest *)setCheckForSoftwareUpdatesWithCompletionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Starts the software update process.
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)softwareUpdateStart:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Removes the notification which is set when a software update was finished.
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)softwareUpdateRemoveNotify:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Gets the current software update status from the bridge.
 @param completionHandler completionHandler for returning the current status and error handling
  @return the request
 */
- (PHRequest *)getSoftwareUpdateStatus:(PHBridgeSendSoftwareUpdateStatusCompletionHandler)completionHandler;

#pragma mark - Backup

- (PHRequest *)startMigration:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

#pragma mark - Scenes

/**
 Gets all scenes from the bridge.
 @param completionHandler completionHandler for returning the current status and error handling
  @return the request
 */
- (PHRequest *)getAllScenesWithCompletionHandler:(PHBridgeSendDictionaryCompletionHandler)completionHandler;

/**
 Save the scene information to the bridge
 @param scene PHScene object that should be saved
 @param completionHandler completionHandler for returning the current status and error handling
  @return the request
 */
- (PHRequest *)saveSceneWithCurrentLightStates:(PHScene *)scene completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Save a specific lightstate for a light in a scene, without changing the current shown lightstate on the light
 @param lightState the lightstate for the light in this scene
 @param lightIdentifier the identifier of the light
 @param sceneIdentifier the identifier of the scene
  @return the request
 */
- (PHRequest *)saveLightState:(PHLightState *)lightState
           forLightIdentifier:(NSString *)lightIdentifier
        inSceneWithIdentifier:(NSString *)sceneIdentifier
            completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Activate scene
 @param sceneIdentifier the identifier of the scene to activate
 @param groupIdentifier the identifier of the group that should apply the scene
 @param completionHandler completionHandler for returning the current status and error handling
  @return the request
 */
- (PHRequest *)activateSceneWithIdentifier:(NSString *)sceneIdentifier onGroup:(NSString *)groupIdentifier completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

#pragma mark - Sensors

/**
 Starts a search for new sensors. This will cancel all other running devices searches (lights or sensors)
 @param delegate A delegate for search status reporting and error handling
 @return the request
 */
- (PHRequest *)searchForNewSensorsWithDelegate:(id<PHSearchForNewDevicesDelegate>)delegate;

/**
 Starts a search for new sensors using the given serials. This will cancel all other running devices searches (lights or sensors)
 @param serials An array of serials (NSStrings of hex characters), maximum of 10
 @param delegate A delegate for search status reporting and error handling
 @return the request
 */
- (PHRequest *)searchForNewSensorsWithSerials:(NSArray *)serials delegate:(id<PHSearchForNewDevicesDelegate>)delegate;

/**
 Get newly found lights since last search for new lights
 @param completionHandler completionHandler for returning this lights found and error handling
 @return the request
 */
- (PHRequest *)getNewFoundSensors:(PHBridgeSendGetNewDevicesCompletionHandler)completionHandler __attribute((deprecated("New found sensors will only return the headers of the sensors found. For complete resources please use the heartbeat meachinism and cache update notifications to get new found resources.")));

/**
 Creates a new sensor
 @param sensor the details of the sensor
 @param completionHandler completionHandler for details of created sensor or error handling
  @return the request
 */
- (PHRequest *)createSensorWithSensor:(PHSensor *)sensor completionHandler:(PHBridgeSendSensorCompletionHandler)completionHandler;

/**
 Updates the sensor information
 @param sensor the sensor to be updated (at least identifier and type attribute should be set)
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)updateSensorWithSensor:(PHSensor *)sensor completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Remove the sensor with the given identifier
 @param sensorIdentifier the identifier of the sensor to remove
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)removeSensorWithId:(NSString*)sensorIdentifier withType:(NSString*)sensorType completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Updates the sensor state
 @param sensorIdentifier the identifier of the sensor to be updated
 @param sensorType the CLIP sensor type of the sensor to be updated
 @param sensorState the sensor state settings to be updated
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)updateSensorStateForId:(NSString*)sensorIdentifier forType:(NSString*)sensorType withSensorState:(PHSensorState*)sensorState completionHandler:
(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Updates the sensor configuration
 @param sensorIdentifier the identifier of the sensor to be updated
 @param sensorType the CLIP sensor type of the sensor to be updated
 @param sensorConfig the sensor configuration to be updated
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)updateSensorConfigForId:(NSString*)sensorIdentifier forType:(NSString*)sensorType withSensorConfig:(PHSensorConfig*)sensorConfig completionHandler:
(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

#pragma mark - Rules

/**
 Creates a new rule
 @param rule the details of the rule
 @param completionHandler completionHandler for details of created sensor or error handling
  @return the request
 */
- (PHRequest *)createRuleWithRule:(PHRule *)rule completionHandler:(PHBridgeSendRuleCompletionHandler)completionHandler;

/**
 Updates the rule configuration
 @param Rule to be updated
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)updateRuleWithRule:(PHRule *)rule completionHandler :(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

/**
 Removes a specific rule
 @param Rule to be removed
 @param completionHandler completionHandler for error handling
  @return the request
 */
- (PHRequest *)removeRuleWithId:(NSString*)ruleIdentifier completionHandler:(PHBridgeSendErrorArrayCompletionHandler)completionHandler;

@end
