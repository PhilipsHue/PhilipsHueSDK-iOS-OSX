/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

/*
 The bitmask options for recurring time formats
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
    RecurringWeekend     = 3,
    RecurringAlldays     = 127,
} RecurringDay;

typedef struct {
    unsigned int start;
    unsigned int end;
} PHTimeInterval;

@interface PHDateTimePattern : NSObject

/**
 
 */
@property (nonatomic, strong) NSDate *date;

/**
 
 */
@property (nonatomic, assign) PHTimeInterval timeInterval;

/**
 
 */
@property (nonatomic, assign) NSInteger timer;

/**
 
 -1: not being set (default)
 */
@property (nonatomic, assign) NSInteger recurringTimerInterval;

/**
 
 */
@property (nonatomic, assign) NSInteger randomTime;

/**
 
 */
@property (nonatomic, assign) RecurringDay recurringDays;


/**
 
 */
- (NSString *)patternAsString;


#pragma mark - Time string formats

/**
 Supported string formats:
 - Absolute time
 [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss]
 [YYYY]-[MM]-[DD]T[hh]:[mm]:[ss]A[hh]:[mm]:[ss] (randomized)
 
 attributes: date, randomTime
 
 - Recurring time
 W[bbb]/T[hh]:[mm]:[ss]
 W[bbb]/T[hh]:[mm]:[ss]A[hh]:[mm]:[ss] (randomized)
 
 attributes: date, randomTime, recurringDays
 
 - Time interval
 T[hh]:[mm]:[ss]-T[hh]:[mm]:[ss]
 
 attributes: timeInterval
 
 - Recurring time interval
 W[bbb]/T[hh]:[mm]:[ss]-T[hh]:[mm]:[ss]
 
 attributes: timeInterval, recurringDays
 
 - Timer
 PT[hh]:[mm]:[ss]
 PT[hh]:[mm]:[ss]A[hh]:[mm]:[ss]
 
 attributes: timer, randomTime, recurringDays
 
 - Recurring timer
 R[nn]/PT[hh]:[mm]:[ss]
 R[nn]/PT[hh]:[mm]:[ss]A[hh]:[mm]:[ss] (randomized)
 
 attributes: timer, recurringTimerInterval, randomTime
 
 Based on ISO8601:2004
 */

/**
 
 */
+ (PHDateTimePattern *)patternWithTimeString:(NSString *)timeString;

@end