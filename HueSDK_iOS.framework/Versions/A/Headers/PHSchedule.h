/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

@class PHLightState;

/*
 The bitmask options for the recurring date
 */
typedef enum {
    RecurringNone        = 0,
    RecurringMonday      = 1 << 6,
    RecurringTuesday     = 1 << 5,
    RecurringWednesday   = 1 << 4,
    RecurringThursday    = 1 << 3,
    RecurringFriday      = 1 << 2,
    RecurringSaturday    = 1 << 1,
    RecurringSunday      = 1 << 0,
    RecurringWeekdays    = 124,
    RecurringWeekend     = 3
} RecurringDay;

/**
 A schedule that specifies a point in time, the state change to be applied,
 and the light or group of lights to apply the change to.
 */
@interface PHSchedule : PHBridgeResource<NSCopying>

/**
 The description of a schedule
 */
@property (nonatomic, strong) NSString *scheduleDescription;

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
 */
@property (nonatomic, strong) NSDate *created;

/**
 The identifier of the light this schedule should have effect on, this
 is only set if this schedule is meant to change a light and not a scene or group.
 */
@property (nonatomic, strong) NSString *lightIdentifier;

/**
 The identifier of the group this schedule should have effect on, this
 is only set if this schedule is meant to change a group and not a scene or light.
 */
@property (nonatomic, strong) NSString *groupIdentifier;

/**
 The identifier of the scene this schedule should have effect on, this
 is only set if this schedule is meant to change a scene and not a group or light.
 */
@property (nonatomic, strong) NSString *sceneIdentifier;

/**
 The state the light or group should be set to.
 */
@property (nonatomic, strong) PHLightState *state;

/**
 returns dictionary of scheule details
 @returns dictionary of schedule details
 */
- (NSDictionary *)getScheduleAsDictionary;


@end