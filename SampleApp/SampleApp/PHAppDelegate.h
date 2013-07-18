/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

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

@property (strong, nonatomic) PHHueSDK *phHueSDK;

/**
 Whether responses regarding the communication with the bridge should be shown
 Note: errors will always be shown 
 */
@property (assign, nonatomic) BOOL showResponses;


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
