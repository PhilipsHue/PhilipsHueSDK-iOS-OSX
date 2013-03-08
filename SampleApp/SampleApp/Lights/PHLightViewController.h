//
//  PHLightViewController.h
//  SDK3rdApp
//
//  Copyright (c) 2012 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHLight;

@interface PHLightViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *sendOn;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *sendHue;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *sendSat;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *sendBri;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *sendXY;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *sendEffect;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *sendAlert;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *sendTransitionTime;

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *valueOn;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *valueHue;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *valueSat;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *valueBri;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *valueX;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *valueY;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *valueEffect;
@property (unsafe_unretained, nonatomic) IBOutlet UISegmentedControl *valueAlert;
@property (unsafe_unretained, nonatomic) IBOutlet UISlider *valueTransitionTime;

@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *yellowButton;
@property (weak, nonatomic) IBOutlet UIButton *violetButton;
@property (weak, nonatomic) IBOutlet UIButton *orangeButton;

@property (weak, nonatomic) IBOutlet UISwitch *correctionSwitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil light:(PHLight *)light;

//- (IBAction)sendState:(id)sender;

- (IBAction)redButton:(id)sender;
- (IBAction)blueButton:(id)sender;
- (IBAction)greenButton:(id)sender;
- (IBAction)yellowButton:(id)sender;
- (IBAction)violetButton:(id)sender;
- (IBAction)orangeButton:(id)sender;

@end
