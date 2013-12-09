/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHAppDelegate.h"
#import "PHGroupAddingViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHGroupAddingViewController ()

@end

@implementation PHGroupAddingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Add group", @"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)createButton:(id)sender {
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    // Create the group
    [bridgeSendAPI createGroupWithName:self.nameTextField.text lightIds:[cache.lights allKeys] completionHandler:^(NSString *groupIdentifier, NSArray *errors) {
        if (UIAppDelegate.showResponses || errors != nil) {
            NSString *message = [NSString stringWithFormat:@"%@: %@\n%@: %@",
                                    NSLocalizedString(@"Group identifier", @""), groupIdentifier != nil ? groupIdentifier : @"",
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
