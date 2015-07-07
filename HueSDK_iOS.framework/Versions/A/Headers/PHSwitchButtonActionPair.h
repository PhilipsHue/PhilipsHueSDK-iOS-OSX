/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSwitchButtonInfo.h"

typedef enum {
    BUTTON_ACTION_SHORT_PRESS,
    BUTTON_ACTION_LONG_PRESS,
    BUTTON_ACTION_PRESS_HOLD,
    BUTTON_ACTION_PRESS_START,
    BUTTON_ACTION_PRESS_RELEASE,
    BUTTON_ACTION_NONE,
    BUTTON_ACTION_INITIAL_PRESSED,
    BUTTON_ACTION_LONG_RELEASED,
    BUTTON_ACTION_SHORT_RELEASED,
    BUTTON_ACTION_HOLD
} PHSwitchButtonAction;

@interface PHSwitchButtonActionPair : NSObject <NSCoding, NSCopying>

/**
 
 */
@property (nonatomic, strong) PHSwitchButtonInfo *buttonInfo;

/**
 
 */
@property (nonatomic, strong) NSNumber *buttonAction;

/**
 Get button action as enumeration value
 @return the enumeration value
 */
- (PHSwitchButtonAction)getButtonActionAsEnum;

/**
 Set the button action with a enumeration value
 @param buttonAction The enumeration value
 */
- (void)setButtonActionWithEnum:(PHSwitchButtonAction)buttonAction;

@end