/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHRuleAction.h"

@class PHLightState;

@interface PHSimpleRuleAction : PHRuleAction

/**
 The scene which must be activated
 */
@property (nonatomic, strong) NSString *sceneIdentifier;

/**
 On which group a scene must be activated
 */
@property (nonatomic, strong) NSString *groupIdentifier;

/*
 Which external event should be triggered (this type of rule action cannot be created
 */
@property (nonatomic, strong) NSString *externalEventName;

/**
 Create action for activating a scene on a group
 */
- (id)initForActivatingScene:(NSString *)sceneIdentifier onGroup:(NSString *)groupIdentifier;


@end
