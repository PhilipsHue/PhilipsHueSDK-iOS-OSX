//
//  PHViewController.h
//  SDK3rdApp
//
//  Copyright (c) 2012 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHConfigurationViewController.h"

@interface PHViewController : UIViewController <PHConfigurationViewControllerDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *currentBridgeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lastLocalHeartbeatLabel;

- (IBAction)showLights:(id)sender;
- (IBAction)showBridgeConfig:(id)sender;

@end
