/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>

@interface PHScheduleAddingViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField  *nameTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
