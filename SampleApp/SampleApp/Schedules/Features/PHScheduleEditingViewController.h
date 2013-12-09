/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>

#include <HueSDK_iOS/HueSDK.h>

@interface PHScheduleEditingViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField  *nameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSchedule:(PHSchedule *)schedule;

@end
