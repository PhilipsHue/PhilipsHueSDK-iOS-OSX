//
//  PHError.h
//  HueSDK v1.0 beta
//
//  Copyright (c) 2012-2013 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SDK_ERROR_DOMAIN @"com.philips.hue.sdk"

typedef enum {
    // Resource parsers
    INVALID_JSON = 1,
    INVALID_ARGUMENTS = 2,
    
    // PHHttpRequester
    NO_CONNECTION = 21,
    INVALID_PARAMETERS = 22,
    INVALID_PARAMETERS_MISSING_URL = 23,
    INVALID_PARAMETERS_MISSING_METHOD = 24,
    INVALID_PARAMETERS_INVALID_METHOD = 25,
    
    // Bridge Resource Cache Storage
    LIGHT_ID_NOT_FOUND = 41,
    SCHEDULE_ID_NOT_FOUND = 42,
    GROUP_ID_NOT_FOUND = 43,
    INVALID_DATA = 44,

	// Pushlinking
    PUSHLINK_NO_CONNECTION = 60,
    PUSHLINK_TIME_LIMIT_REACHED = 61,
    PUSHLINK_NO_LOCAL_BRIDGE = 62,
    
    CLIP_ERROR = 100
} CLErrorCode;

/**
	General purpose NSError derived object that is used for SDK errors
    Enum of error codes identifies error types
 */
@interface PHError : NSError

@end
