/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHAppDelegate.h"
#import "PHScheduleEditingViewController.h"

@interface PHScheduleEditingViewController ()

@property (strong, nonatomic) PHSchedule *schedule;

@end

@implementation PHScheduleEditingViewController

@synthesize schedule = _schedule;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSchedule:(PHSchedule *)schedule {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.schedule = schedule;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextField.text = self.schedule.name;
    self.datePicker.date = self.schedule.date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)editButton:(id)sender {
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];

    self.schedule.identifier = self.schedule.identifier;
    self.schedule.name = self.nameTextField.text;
    self.schedule.date = self.datePicker.date;
    
    // Update the schedule
    [bridgeSendAPI updateScheduleWithSchedule:self.schedule completionHandler:^(NSArray *errors) {
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

@end
