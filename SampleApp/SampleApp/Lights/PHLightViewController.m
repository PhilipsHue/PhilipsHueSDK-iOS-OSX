//
//  PHLightViewController.m
//  SDK3rdApp
//
//  Copyright (c) 2012 Philips. All rights reserved.
//

#import "PHLightViewController.h"

#import <HueSDK/SDK.h>

@interface PHLightViewController ()

@property (nonatomic, strong) PHLight *light;

@end

@implementation PHLightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil light:(PHLight *)light {
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(sendState:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSendOn:nil];
    [self setSendHue:nil];
    [self setSendSat:nil];
    [self setSendBri:nil];
    [self setSendXY:nil];
    [self setSendEffect:nil];
    [self setSendAlert:nil];
    [self setValueOn:nil];
    [self setValueHue:nil];
    [self setValueSat:nil];
    [self setValueBri:nil];
    [self setValueX:nil];
    [self setValueY:nil];
    [self setValueEffect:nil];
    [self setValueAlert:nil];
    [self setSendTransitionTime:nil];
    [self setValueTransitionTime:nil];
    [super viewDidUnload];
}

/**
 Action for the send state local button
 */
- (IBAction)sendState:(id)sender {
    // Create a lightstate based on selected options
    PHLightState *lightState = [self createLightState];
    
    /***************************************************
     The BridgeSendAPI is used to send commands to the bridge.
     Here we are updating the settings chosen by the user
     for the selected light.
     These settings are sent as a PHLightState to update
     the light with the given light identifiers.
     Subsequent checking of the Bridge Resources cache after the next heartbeat will
     show that changed settings have occurred.
     *****************************************************/
    
    // Create a bridge send api, used for sending commands to bridge locally
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    // Send lightstate to light
    [bridgeSendAPI updateLightStateForId:self.light.identifier withLighState:lightState completionHandler:^(NSArray *errors) {
        // Check for errors
        if (errors != nil) {
            
            for (PHError *error in errors) {
                // Error occured
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:error.description
                                                                    delegate:nil
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"Ok", nil];
                [errorAlert show];
            }
        }
    }];
    
}

- (IBAction)redButton:(id)sender {
    [self setupForColor:[UIColor redColor]];
}

- (IBAction)blueButton:(id)sender {
    [self setupForColor:[UIColor blueColor]];
}

- (IBAction)greenButton:(id)sender {
    [self setupForColor:[UIColor greenColor]];
}

- (IBAction)yellowButton:(id)sender {
    [self setupForColor:[UIColor yellowColor]];
}

- (IBAction)violetButton:(id)sender {
    [self setupForColor:[UIColor purpleColor]];
}

- (IBAction)orangeButton:(id)sender {
    [self setupForColor:[UIColor orangeColor]];
}

- (void)setupForColor:(UIColor *)color {
    CGPoint xyPoint;
    float brightness;
    
    if ([self.correctionSwitch isOn]) {
        [PHUtilities calculateXY:&xyPoint andBrightness:&brightness fromColor:color forModel:self.light.modelNumber];
    }
    else {
        [PHUtilities calculateXY:&xyPoint andBrightness:&brightness fromColor:color forModel:@""];
    }
    
    self.sendHue.on = NO;
    self.sendSat.on = NO;
    self.sendEffect.on = NO;
    self.sendAlert.on = NO;
    self.sendTransitionTime.on = NO;
    
    self.sendOn.on = YES;
    self.valueOn.on = YES;
    self.sendBri.on = YES;
    self.valueBri.value = 255.0f;
    self.sendXY.on = YES;
    self.valueX.value = xyPoint.x;
    self.valueY.value = xyPoint.y;
}

/**
 Creates a lightstate based on selected options in the user interface
 @return the lightstate
 */
- (PHLightState *)createLightState {
    /***************************************************
     The PHLightState class is used as a parameter for the
     Hue SDK. It contains the attribute settings for an individual\
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
        [lightState setHue:[NSNumber numberWithInt:((int)self.valueHue.value)]];
    }
    
    // Check if saturation value should be send
    if (self.sendSat.on) {
        [lightState setSaturation:[NSNumber numberWithInt:((int)self.valueSat.value)]];
    }
    
    // Check if brightness value should be send
    if (self.sendBri.on) {
        [lightState setBrightness:[NSNumber numberWithInt:((int)self.valueBri.value)]];
    }
    
    // Check if xy values should be send
    if (self.sendXY.on) {
        [lightState setX:[NSNumber numberWithFloat:self.valueX.value]];
        [lightState setY:[NSNumber numberWithFloat:self.valueY.value]];
    }
    
    // Check if effect value should be send
    if (self.sendEffect.on) {
        if (self.valueEffect.selectedSegmentIndex == 0) {
            [lightState setEffectMode:EFFECT_NONE];
        }
        else if (self.valueEffect.selectedSegmentIndex == 1) {
            [lightState setEffectMode:EFFECT_COLORLOOP];
        }
    }
    
    // Check if alert value should be send
    if (self.sendAlert.on) {
        if (self.valueAlert.selectedSegmentIndex == 0) {
            [lightState setAlertMode:ALERT_NONE];
        }
        else if (self.valueAlert.selectedSegmentIndex == 1) {
            [lightState setAlertMode:ALERT_SELECT];
        }
        else if (self.valueAlert.selectedSegmentIndex == 2) {
            [lightState setAlertMode:ALERT_LSELECT];
        }
    }
    
    // Check if transition time should be send
    if (self.sendTransitionTime.on) {
        [lightState setTransitionTime:[NSNumber numberWithInt:((int)self.valueTransitionTime.value)]];
    }
    
    return lightState;
}

@end
