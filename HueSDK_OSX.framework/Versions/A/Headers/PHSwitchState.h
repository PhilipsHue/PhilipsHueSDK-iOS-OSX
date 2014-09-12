/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSensorState.h"

typedef enum {
    BUTTON_EVENT_UNKNOWN = 0,
    BUTTON_EVENT_CODE_SCENE_1 = 16,
    BUTTON_EVENT_CODE_SCENE_2 = 17,
    BUTTON_EVENT_CODE_SCENE_3 = 18,
    BUTTON_EVENT_CODE_SCENE_4 = 19,
    BUTTON_EVENT_CODE_SCENE_5 = 20,
    BUTTON_EVENT_CODE_SCENE_6 = 21,
    BUTTON_EVENT_CODE_SCENE_7 = 22,
    BUTTON_EVENT_CODE_SCENE_8 = 23,
    BUTTON_EVENT_CODE_TOGGLE = 34,
    BUTTON_EVENT_CODE_PRESS_BUTTON_1 = 98,
    BUTTON_EVENT_CODE_RELEASE_BUTTON_1 = 99,
    BUTTON_EVENT_CODE_PRESS_BUTTON_2 = 100,
    BUTTON_EVENT_CODE_RELEASE_BUTTON_2 = 101
} PHSwitchStateButtonEventCode;

@interface PHSwitchState : PHSensorState

/**
 Code of last switch event
 
 Only readwrite for CLIP sensor
 */
@property (nonatomic, strong) NSNumber* buttonEvent;

/**
 Get button event as enumeration value
 @return the enumeration value
 */
- (PHSwitchStateButtonEventCode)getButtonEventAsEnum;

/**
 Set the button event with a enumeration value
 @param eventCode The enumeration value
 */
- (void)setButtonEventWithEnum:(PHSwitchStateButtonEventCode)buttonEvent;

@end
