/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHBridgeResource.h"

/**
 A rule and it settings
 */
@interface PHRule : PHBridgeResource<NSCoding, NSCopying>

/**
 The date of the last time the rule was triggered (if the rule has ever been triggered).
 */
@property (nonatomic, strong) NSDate *lastTriggered;

/**
 The absolute number of time a rule was triggered
 */
@property (nonatomic, strong) NSNumber *timesTriggered;

/**
 The date of the time the rule was created
 */
@property (nonatomic, strong) NSDate *creationTime;

/**
 The username of the application which created the rule resp. the last application changing the rule. 
 "none" if the username has been deleted.
 */
@property (nonatomic, strong) NSString *owner;

/**
 Status of the rule
 enabled   -> allowed to set
 disabled  -> allowed to set
 loopError
 typError
 operator
 methodError
 bodyError
 serverError
 resourceDeleted
 error
 */
@property (nonatomic, strong) NSString *status;

/**
 Conditions are combined with AND. Actions are only performed when all conditions are true and at least 
 one condition changed from false to true resp. precise the moment in time dx, dt or eq recurring time 
 is true.
 */
@property (nonatomic, strong) NSArray *conditions;

/**
 List of action that should be executed when the all the conditions are met.
 */
@property (nonatomic, strong) NSArray *actions;

@end
