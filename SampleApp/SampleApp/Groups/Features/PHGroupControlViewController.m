/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHAppDelegate.h"
#import "PHGroupControlViewController.h"

@interface PHGroupControlViewController ()

@property (strong, nonatomic) PHGroup *group;

@end

@implementation PHGroupControlViewController

@synthesize group = _group;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andGroup:(PHGroup *)group {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.group = group;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.group.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sendButton:(id)sender {
    // Create a lightstate based on selected options
    PHLightState *lightState = [super createLightState];
    
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    // Update the light state of the group
    [bridgeSendAPI setLightStateForGroupWithId:self.group.identifier lightState:lightState completionHandler:^(NSArray *errors) {
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

@end
