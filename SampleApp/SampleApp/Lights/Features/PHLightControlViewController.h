/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>

#include <HueSDK_iOS/HueSDK.h>

@interface PHLightControlViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;

@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UISwitch *sendOn;
@property (weak, nonatomic) IBOutlet UISwitch *sendHue;
@property (weak, nonatomic) IBOutlet UISwitch *sendSat;
@property (weak, nonatomic) IBOutlet UISwitch *sendBri;
@property (weak, nonatomic) IBOutlet UISwitch *sendXY;
@property (weak, nonatomic) IBOutlet UISwitch *sendEffect;
@property (weak, nonatomic) IBOutlet UISwitch *sendAlert;
@property (weak, nonatomic) IBOutlet UISwitch *sendTransitionTime;

@property (weak, nonatomic) IBOutlet UISwitch    *valueOn;
@property (weak, nonatomic) IBOutlet UISlider    *valueHueSlider;
@property (weak, nonatomic) IBOutlet UITextField *valueHueTextField;
@property (weak, nonatomic) IBOutlet UISlider    *valueSatSlider;
@property (weak, nonatomic) IBOutlet UITextField *valueSatTextField;
@property (weak, nonatomic) IBOutlet UISlider    *valueBriSlider;
@property (weak, nonatomic) IBOutlet UITextField *valueBriTextField;
@property (weak, nonatomic) IBOutlet UISlider    *valueXSlider;
@property (weak, nonatomic) IBOutlet UITextField *valueXTextField;
@property (weak, nonatomic) IBOutlet UISlider    *valueYSlider;
@property (weak, nonatomic) IBOutlet UITextField *valueYTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *valueEffect;
@property (weak, nonatomic) IBOutlet UISegmentedControl *valueAlert;
@property (weak, nonatomic) IBOutlet UISlider    *valueTransitionTimeSlider;
@property (weak, nonatomic) IBOutlet UITextField *valueTransitionTimeTextField;

@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *violetButton;
@property (weak, nonatomic) IBOutlet UIButton *orangeButton;

@property (weak, nonatomic) IBOutlet UISwitch *correctionSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLight:(PHLight *)light;

- (IBAction)redButton:(id)sender;
- (IBAction)blueButton:(id)sender;
- (IBAction)greenButton:(id)sender;
- (IBAction)yellowButton:(id)sender;
- (IBAction)violetButton:(id)sender;
- (IBAction)orangeButton:(id)sender;

- (IBAction)readButton:(id)sender;
- (IBAction)sendButton:(id)sender;

- (PHLightState *)createLightState;

@end
