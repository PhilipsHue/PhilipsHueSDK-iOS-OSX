/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHAppDelegate.h"
#import "PHLightControlViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHLightControlViewController ()

@property (strong, nonatomic) PHLight *light;

@end

@implementation PHLightControlViewController

@synthesize light = _light;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andLight:(PHLight *)light {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.light = light;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.light.name;
    
    self.redButton.backgroundColor = [UIColor redColor];
    self.blueButton.backgroundColor = [UIColor blueColor];
    self.greenButton.backgroundColor = [UIColor greenColor];
    self.yellowButton.backgroundColor = [UIColor yellowColor];
    self.violetButton.backgroundColor = [UIColor purpleColor];
    self.orangeButton.backgroundColor = [UIColor orangeColor];
    
    [self.scrollView setContentSize:self.scrollContentView.frame.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)redButton:(id)sender {
    [self setupForColor:[UIColor redColor] andModel:self.light.modelNumber];
}

- (IBAction)blueButton:(id)sender {
    [self setupForColor:[UIColor blueColor] andModel:self.light.modelNumber];
}

- (IBAction)greenButton:(id)sender {
    [self setupForColor:[UIColor greenColor] andModel:self.light.modelNumber];
}

- (IBAction)yellowButton:(id)sender {
    [self setupForColor:[UIColor yellowColor] andModel:self.light.modelNumber];
}

- (IBAction)violetButton:(id)sender {
    [self setupForColor:[UIColor purpleColor] andModel:self.light.modelNumber];
}

- (IBAction)orangeButton:(id)sender {
    [self setupForColor:[UIColor orangeColor] andModel:self.light.modelNumber];
}

- (IBAction)hueSliderValueChanged:(id)sender {
    self.valueHueTextField.text = [NSString stringWithFormat:@"%i", (int)self.valueHueSlider.value];
}

- (IBAction)hueTextFieldValueChanged:(id)sender {
    int hue = [self.valueHueTextField.text intValue];
    
    // Check if the hue is out of range
    if (hue > 65535) {
        hue = 65535;
    }
    else if (hue < 0) {
        hue = 0;
    }
    
    self.valueHueTextField.text = [NSString stringWithFormat:@"%i", hue];
    self.valueHueSlider.value = (float)hue;
}

- (IBAction)satSliderValueChanged:(id)sender {
    self.valueSatTextField.text = [NSString stringWithFormat:@"%i", (int)self.valueSatSlider.value];
}

- (IBAction)satTextFieldValueChanged:(id)sender {
    int saturation = [self.valueSatTextField.text intValue];
    
    // Check if the saturation is out of range
    if (saturation > 254) {
        saturation = 254;
    }
    else if (saturation < 0) {
        saturation = 0;
    }
    
    self.valueSatTextField.text = [NSString stringWithFormat:@"%i", saturation];
    self.valueSatSlider.value = (float)saturation;
}

- (IBAction)briSliderValueChanged:(id)sender {
    self.valueBriTextField.text = [NSString stringWithFormat:@"%i", (int)self.valueBriSlider.value];
}

- (IBAction)briTextFieldValueChanged:(id)sender {
    int brightness = [self.valueBriTextField.text intValue];
    
    // Check if the brightness is out of range
    if (brightness > 254) {
        brightness = 254;
    }
    else if (brightness < 0) {
        brightness = 0;
    }
    
    self.valueBriTextField.text = [NSString stringWithFormat:@"%i", brightness];
    self.valueBriSlider.value = (float)brightness;
}

- (IBAction)xSliderValueChanged:(id)sender {
    self.valueXTextField.text = [NSString stringWithFormat:@"%.4f", self.valueXSlider.value];
}

- (IBAction)xTextFieldValueChanged:(id)sender {
    float x = [self.valueXTextField.text doubleValue];
    
    // Check if the x is out of range
    if (x > 1.0f) {
        x = 1.0f;
    }
    else if (x < 0.0f) {
        x = 0.0f;
    }
    
    self.valueXTextField.text = [NSString stringWithFormat:@"%.4f", x];
    self.valueXSlider.value = x;
}

- (IBAction)ySliderValueChanged:(id)sender {
    self.valueYTextField.text = [NSString stringWithFormat:@"%.4f", self.valueYSlider.value];
}

- (IBAction)yTextFieldValueChanged:(id)sender {
    float y = [self.valueYTextField.text doubleValue];
    
    // Check if the y is out of range
    if (y > 1.0f) {
        y = 1.0f;
    }
    else if (y < 0.0f) {
        y = 0.0f;
    }
    
    self.valueYTextField.text = [NSString stringWithFormat:@"%.4f", y];
    self.valueYSlider.value = y;
}

- (IBAction)transitionTimeSliderValueChanged:(id)sender {
    self.valueTransitionTimeTextField.text = [NSString stringWithFormat:@"%i", (int)self.valueTransitionTimeSlider.value];
}

- (IBAction)transitionTimeTextFieldValueChanged:(id)sender {
    int transitionTime = [self.valueTransitionTimeTextField.text intValue];
    
    // Check if the transition time is out of range
    if (transitionTime > 65535) {
        transitionTime = 65535;
    }
    else if (transitionTime < 0) {
        transitionTime = 0;
    }
    
    self.valueTransitionTimeTextField.text = [NSString stringWithFormat:@"%i", transitionTime];
    self.valueTransitionTimeSlider.value = transitionTime;
}

- (IBAction)readButton:(id)sender {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    // Populate the form with the current light state of the light
    [self populateViewWithLightState:[[cache.lights objectForKey:self.light.identifier] lightState]];
}

- (IBAction)sendButton:(id)sender {
    // Create a lightstate based on selected options
    PHLightState *lightState = [self createLightState];
    
    /***************************************************
     The BridgeSendAPI is used to send commands to the bridge.
     Here we are updating the settings chosen by the user
     for the selected light.
     These settings are sent as a PHLightState to update
     the light with the given light identifiers.
     *****************************************************/
    
    // Create a bridge send api, used for sending commands to bridge locally
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    // Send lightstate to light
    [bridgeSendAPI updateLightStateForId:self.light.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
        if (UIAppDelegate.showResponses || errors != nil) {
            NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Response", @"")
                                                                 message:message
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
            [errorAlert show];
        }
    }];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Close keyboard after editing a text field
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Helpers

- (void)setupForColor:(UIColor *)color andModel:(NSString *)model {
    CGPoint xyPoint;
    float brightness;
    
    if ([self.correctionSwitch isOn]) {
        xyPoint = [PHUtilities calculateXY:color forModel:model];
    }
    else {
        [PHUtilities calculateXY:color forModel:@""];
    }
    
    self.sendOn.on = YES;
    self.valueOn.on = YES;
    self.sendBri.on = YES;
    self.valueBriSlider.value = 254.0f;
    self.valueBriTextField.text = @"254";
    self.sendHue.on = NO;
    self.sendSat.on = NO;
    self.sendXY.on = YES;
    self.valueXSlider.value = xyPoint.x;
    self.valueXTextField.text = [NSString stringWithFormat:@"%.4f", xyPoint.x];
    self.valueYSlider.value = xyPoint.y;
    self.valueYTextField.text = [NSString stringWithFormat:@"%.4f", xyPoint.y];
}

/**
 Creates a lightstate based on selected options in the user interface
 @return the lightstate
 */
- (PHLightState *)createLightState {
    /***************************************************
     The PHLightState class is used as a parameter for the
     Hue SDK. It contains the attribute settings for an individual
     light. This method creates it from the current
     user interface settings for the light
     *****************************************************/
    
    // Create an empty lightstate
    PHLightState *lightState = [[PHLightState alloc] init];
    
    // Check if on value should be send
    if (self.sendOn.on) {
        [lightState setOnBool:self.valueOn.on];
    }
    
    // Check if hue value should be send
    if (self.sendHue.on) {
        [lightState setHue:[NSNumber numberWithInt:((int)self.valueHueSlider.value)]];
    }
    
    // Check if saturation value should be send
    if (self.sendSat.on) {
        [lightState setSaturation:[NSNumber numberWithInt:((int)self.valueSatSlider.value)]];
    }
    
    // Check if brightness value should be send
    if (self.sendBri.on) {
        [lightState setBrightness:[NSNumber numberWithInt:((int)self.valueBriSlider.value)]];
    }
    
    // Check if xy values should be send
    if (self.sendXY.on) {
        [lightState setX:[NSNumber numberWithFloat:self.valueXSlider.value]];
        [lightState setY:[NSNumber numberWithFloat:self.valueYSlider.value]];
    }
    
    // Check if effect value should be send
    if (self.sendEffect.on) {
        if (self.valueEffect.selectedSegmentIndex == 0) {
            lightState.effect = EFFECT_NONE;
        }
        else if (self.valueEffect.selectedSegmentIndex == 1) {
            lightState.effect = EFFECT_COLORLOOP;
        }
    }
    
    // Check if alert value should be send
    if (self.sendAlert.on) {
        if (self.valueAlert.selectedSegmentIndex == 0) {
            lightState.alert = ALERT_NONE;
        }
        else if (self.valueAlert.selectedSegmentIndex == 1) {
            lightState.alert = ALERT_SELECT;
        }
        else if (self.valueAlert.selectedSegmentIndex == 2) {
            lightState.alert = ALERT_LSELECT;
        }
    }
    
    // Check if transition time should be send
    if (self.sendTransitionTime.on) {
        [lightState setTransitionTime:[NSNumber numberWithInt:((int)self.valueTransitionTimeSlider.value)]];
    }
    
    return lightState;
}

/**
 Populate the view with the values of a light state
 @param lightState The light state which will be used for populating the view
 */
- (void)populateViewWithLightState:(PHLightState *)lightState {
    if (lightState.on != nil) {
        self.valueOn.on = [[lightState on] boolValue];
    }
    else {
        self.valueOn.on = NO;
    }
    
    if (lightState.hue != nil) {
        self.valueHueSlider.value = [lightState.hue floatValue];
        self.valueHueTextField.text = [NSString stringWithFormat:@"%i", [lightState.hue intValue]];
    }
    else {
        self.valueHueSlider.value = 0.0;
        self.valueHueTextField.text = @"0";
    }
    
    if (lightState.saturation != nil) {
        self.valueSatSlider.value = [lightState.saturation floatValue];
        self.valueSatTextField.text = [NSString stringWithFormat:@"%i", [lightState.saturation intValue]];
    }
    else {
        self.valueSatSlider.value = 0.0;
        self.valueSatTextField.text = @"0";
    }
    
    if (lightState.brightness != nil) {
        self.valueBriSlider.value = [lightState.brightness floatValue];
        self.valueBriTextField.text = [NSString stringWithFormat:@"%i", [lightState.brightness intValue]];
    }
    else {
        self.valueBriSlider.value = 0.0;
        self.valueSatTextField.text = @"0";
    }
    
    if (lightState.x != nil && lightState.y != nil) {
        self.valueXSlider.value = [lightState.x floatValue];
        self.valueXTextField.text = [NSString stringWithFormat:@"%.4f", [lightState.x floatValue]];
        self.valueYSlider.value = [lightState.y floatValue];
        self.valueYTextField.text = [NSString stringWithFormat:@"%.4f", [lightState.y floatValue]];
    }
    else {
        self.valueXSlider.value = 0.0;
        self.valueHueTextField.text = @"0";
        self.valueYSlider.value = 0.0;
        self.valueHueTextField.text = @"0";
    }

    PHLightEffectMode effectMode = lightState.effect;
    
    if (effectMode == EFFECT_NONE) {
        self.valueEffect.selectedSegmentIndex = 0;
    }
    else if (effectMode == EFFECT_COLORLOOP) {
        self.valueEffect.selectedSegmentIndex = 1;
    }
    else {
        self.valueEffect.selectedSegmentIndex = 0;
    }
    
    PHLightAlertMode alertMode = lightState.alert;
    
    if (alertMode == ALERT_NONE) {
        self.valueAlert.selectedSegmentIndex = 0;
    }
    else if (alertMode == ALERT_SELECT) {
        self.valueAlert.selectedSegmentIndex = 1;
    }
    else if (alertMode == ALERT_LSELECT) {
        self.valueAlert.selectedSegmentIndex = 2;
    }
    else {
        self.valueAlert.selectedSegmentIndex = 0;
    }
    
    if (lightState.transitionTime != nil) {
        self.valueTransitionTimeSlider.value = [lightState.transitionTime floatValue];
        self.valueTransitionTimeTextField.text = [NSString stringWithFormat:@"%i", [lightState.transitionTime intValue]];
    }
    else {
        self.valueTransitionTimeSlider.value = 0.0f;
        self.valueTransitionTimeTextField.text = @"0";
    }
}

@end
