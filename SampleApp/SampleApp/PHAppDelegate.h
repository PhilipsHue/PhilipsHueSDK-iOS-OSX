//
//  PHAppDelegate.h
//  SDK3rdApp
//
//  Copyright (c) 2012 Philips. All rights reserved.
//

#define UIAppDelegate  ((PHAppDelegate *)[[UIApplication sharedApplication] delegate])

#import <UIKit/UIKit.h>

#import "PHBridgeSelectionViewController.h"
#import "PHBridgePushLinkViewController.h"
#import "PHSoftwareUpdateManager.h"

@class ViewController;
@class PHHueSDK;

@interface PHAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, PHBridgeSelectionViewControllerDelegate, PHBridgePushLinkViewControllerDelegate, PHSoftwareUpdateManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, strong) PHHueSDK *phHueSDK;

#pragma mark - HueSDK

/**
 Starts the local heartbeat
 */
- (void)enableLocalHeartbeat;

/**
 Stops the local heartbeat
 */
- (void)disableLocalHeartbeat;

/**
 Starts a search for a bridge
 */
- (void)searchForBridgeLocal;

@end
