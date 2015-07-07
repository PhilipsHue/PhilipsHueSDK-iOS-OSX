/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"
#import "PHDateTimePattern.h"

typedef enum {
    SCHEDULE_STATUS_ENABLED, // Settable to bridge
    SCHEDULE_STATUS_DISABLED, // Settable to bridge
    SCHEDULE_STATUS_RESOURCE_DELETED,
    SCHEDULE_STATUS_ERROR,
    SCHEDULE_STATUS_UNKNOWN
} PHScheduleStatus;

@class PHLightState;

/**
 A schedule that specifies a point in time, the state change to be applied,
 and the light or group of lights to apply the change to.
 */
@interface PHSchedule : PHBridgeResource<NSCoding, NSCopying>

/**
 The description of a schedule
 */
@property (nonatomic, strong) NSString *scheduleDescription;

/**
 Whether this schedule is in local time
 Default: NO
 */
@property (nonatomic, assign) BOOL localTime;

/**
 The date a schedule is set to fire
 */
@property (nonatomic, strong) NSDate *date;

/**
 The randomize time to use for the schedule.
 Maximum value is 86400 (24 hours)
 When set to 0 (default) no randomize factor will be used.
 */
@property (nonatomic, assign) NSTimeInterval randomTime;

/**
 A bitmask of the days this should recur, default is RecurringNone.
 @see RecurringDay
 */
@property (nonatomic, assign) RecurringDay recurringDays;

/**
 The timer to use for the schedule.
 (date value should be nil and the recurringDays value should be 0 if you use a schedule timer)
 Maximum value is 86400 (24 hours)
 When set to 0 (default) no timer will be used.
 */
@property (nonatomic, assign) NSTimeInterval timer;

/**
 The recurring timer interval which represents how many times the timer will be executed
 (date value should be nil and the recurringDays value should be 0 if you use a schedule timer)
 Minimum value is 0
 Maximum value is 99
 When set to 0 (default) no timer interval will be used.
 */
@property (nonatomic, strong) NSNumber *recurringTimerInterval;

/**
 The date the schedule was created
 UTC
 */
@property (nonatomic, strong) NSDate *created;

/**
 The date the schedule was started, only for timers
 UTC
 */
@property (nonatomic, strong) NSDate *starttime;

/**
 The identifier of the light this schedule should have effect on, this
 is only set if this schedule is meant to change a light and not a scene or group.
 */
@property (nonatomic, strong) NSString *lightIdentifier;

/**
 The identifier of the group this schedule should have effect on. This is only set in case the schedule is meant to change a
 group or when the schedule is meant to recall a scene. In this last case the groupIdentifier is used to specify on which
 group the scene has to be applied.
 */
@property (nonatomic, strong) NSString *groupIdentifier;

/**
 The identifier of the scene this schedule should have effect on. Should be set together with the groupIdentifier on which
 the scene has to be applied. This is only set if this schedule is meant to change a scene and not a group or light.
 */
@property (nonatomic, strong) NSString *sceneIdentifier;

/**
 The state the light or group should be set to.
 */
@property (nonatomic, strong) PHLightState *state;

/**
 The username of the application which created the rule resp. the last application changing the rule.
 "none" if the username has been deleted.
 */
@property (nonatomic, strong) NSString *owner;

/**
 Status of the schedule
 */
@property (nonatomic, strong) NSString *status;

/**
 Autodelete flag of the schedule. If set to true schedule will be removed automatically if expired, if set to false it will be disabled. Only applicable for schedules which expire like timers.
 */
@property (nonatomic, strong) NSNumber *autoDelete;

/**
 * Get the status of the schedule as enum value
 */
- (PHScheduleStatus)statusAsEnum;

/**
 * Set the status of the schedule as enum value
 * Only enable/disable enum values are settable
 * @param status The enum value
 */
- (void)setStatusAsEnum:(PHScheduleStatus)status;

@end