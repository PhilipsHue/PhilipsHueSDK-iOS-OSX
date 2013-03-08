//
//  PHViewController.m
//  SDK3rdApp
//
//  Copyright (c) 2012 Philips. All rights reserved.
//

#import "PHViewController.h"
#import "PHLightsViewController.h"
#import "PHAppDelegate.h"

#import <HueSDK/SDK.h>

@interface PHViewController ()

@end

@implementation PHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"Sample app";
    /***************************************************
     The localConnection notification will notify that 
     the bridge heartbeat occurred and the bridge resources
     cache data has been updated
     *****************************************************/
    
    // Listen for notifications
    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setCurrentBridgeLabel:nil];
    [self setLastLocalHeartbeatLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Button actions

/**
 Action for the show lights button
 */
- (IBAction)showLights:(id)sender {
    /***************************************************
     Show the lights view controller for the lights 
     status
     *****************************************************/

    PHLightsViewController *lightsViewController = [[PHLightsViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
    [self.navigationController pushViewController:lightsViewController animated:YES];
}

/**
 Action for the show configuration button
 */
- (IBAction)showBridgeConfig:(id)sender {
    PHConfigurationViewController *configViewController = [[PHConfigurationViewController alloc] initWithNibName:@"PHConfigurationViewController"
                                                                                                          bundle:[NSBundle mainBundle]
                                                                                                          hueSDK:UIAppDelegate.phHueSDK
                                                                                                        delegate:self];
    
    UINavigationController *configNavController = [[UINavigationController alloc] initWithRootViewController:configViewController];
    configNavController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self.navigationController presentViewController:configNavController animated:YES completion:NULL];
}
#pragma mark - Configuration view controller delegate

- (void)closeConfigurationView:(PHConfigurationViewController *)configurationView {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)startSearchForBridge:(PHConfigurationViewController *)configurationView {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    [UIAppDelegate searchForBridgeLocal];
}

#pragma mark - Notification receivers

/**
 Notification receiver for successful local connection
 */
- (void)localConnection {
    /***************************************************
     PHBridgeResourcesReader readBridgeResourcesCache, 
     returns the up to date PHBridgeResourcesCache status
     Here it is used to display the bridge ipaddress
     *****************************************************/

    // Read latest cache, update ip of bridge in interface
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    self.currentBridgeLabel.text = cache.bridgeConfiguration.ipaddress;
    
    // Set current time as last successful local heartbeat time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    /***************************************************
     Displays the current time to show when the last
     heartbeat was executed.
     *****************************************************/
    
    self.lastLocalHeartbeatLabel.text = [dateFormatter stringFromDate:[NSDate date]];
}

/**
 Notification receiver for failed local connection
 */
- (void)noLocalConnection {
    // Update connection status label
    self.lastLocalHeartbeatLabel.text = @"No connection";
}

@end
