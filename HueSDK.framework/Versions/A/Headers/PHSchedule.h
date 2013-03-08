//
//  PHSchedule.h
//  HueSDK v1.0 beta
//
//  Copyright (c) 2012-2013 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

@class PHLightState;

/**
 A schedule that specifies a point in time, the state change to be applied,
 and the light or group of lights to apply the change to.
 */
@interface PHSchedule : PHBridgeResource

/**
 The description of a schedule
 */
@property (nonatomic, strong) NSString *scheduleDescription;

/**
 The date a schedule is set to fire
 */
@property (nonatomic, strong) NSDate *date;

/**
 The identifier of the light this schedule should have effect on, this
 is only set if this schedule is meant to change a light and not a group.
 */
@property (nonatomic, strong) NSString *lightIdentifier;

/**
 The identifier of the group this schedule should have effect on, this
 is only set if this schedule is meant to change a group and not a light.
 */
@property (nonatomic, strong) NSString *groupIdentifier;

/**
 The state the light or group should be set to.
 */
@property (nonatomic, strong) PHLightState *state;
/**
 returns dictionary of scheule details
 @returns dictionary of schedule details
 */
- (NSDictionary *) getScheduleAsDictionary;


@end