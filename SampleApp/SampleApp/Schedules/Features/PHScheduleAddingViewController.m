/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHAppDelegate.h"
#import "PHScheduleAddingViewController.h"

#include <HueSDK_iOS/HueSDK.h>

@interface PHScheduleAddingViewController ()

@end

@implementation PHScheduleAddingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker.date = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addButton:(id)sender {
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    PHSchedule *schedule = [[PHSchedule alloc] init];
    schedule.name = self.nameTextField.text;
    schedule.scheduleDescription = @"Test schedule";
    schedule.date = self.datePicker.date;
    schedule.groupIdentifier = @"0";
    
    // The lights start blinking when the schedule is executed
    PHLightState *lightState = [[PHLightState alloc] init];
    lightState.alert = ALERT_LSELECT;
    
    schedule.state = lightState;
    
    // Create the schedule
    [bridgeSendAPI createSchedule:schedule completionHandler:^(NSString *scheduleIdentifier, NSArray *errors) {
        if (UIAppDelegate.showResponses || errors != nil) {
            NSString *message = [NSString stringWithFormat:@"%@: %@\n%@: %@",
                                 NSLocalizedString(@"Schedule identifier", @""), scheduleIdentifier != nil ? scheduleIdentifier : @"",
                                 NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
            
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

@end
