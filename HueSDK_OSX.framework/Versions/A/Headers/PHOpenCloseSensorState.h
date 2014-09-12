/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

@interface PHOpenCloseSensorState : PHSensorState

/**
 Whether the switch is open
 YES means open, NO means closed.
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber *open;

@end
