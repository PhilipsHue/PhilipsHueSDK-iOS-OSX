/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorConfig.h"

@interface PHDaylightSensorConfig : PHSensorConfig

/**
 GPS coordinates 
 
 Readwrite
 */
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;

/**
 Timeoffset in minutes to sunrise
 Range: -120 min - 120 min
 
 Readwrite
 */
@property (nonatomic, strong) NSNumber *sunriseOffset;

/**
 Timeoffset in minutes to sunset
 Range: -120 min - 120 min
 
 Readwrite
 */
@property (nonatomic, strong) NSNumber *sunsetOffset;

@end
