/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHGeofenceSensorState : PHSensorState

/**
 Whether presence has been detected
 YES means that presence has been detected, NO means no presence has been detected.
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *presence;

@end
