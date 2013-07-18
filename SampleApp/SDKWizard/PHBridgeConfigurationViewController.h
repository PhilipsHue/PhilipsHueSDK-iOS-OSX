/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import "PHSoftwareUpdateManager.h"

@class PHBridgeConfigurationViewController;

@protocol PHBridgeConfigurationViewControllerDelegate <NSObject>

/**
 This method is called when the save button on the configuration screen is tapped and the save went ok.
 @param bridgeConfigurationViewController The bridge configuration view that called this method
 */
- (void)closeBridgeConfigurationViewController:(PHBridgeConfigurationViewController *)bridgeConfigurationViewController;

@end

/**
 This is the bridge configuration sdk wizard. You can plug this viewcontroller into your application
 to allow changing of the bridge settings from your app. You should change this class
 to include memory management if you are not using ARC.
 */
@interface PHBridgeConfigurationViewController : UITableViewController <UITextFieldDelegate, PHSoftwareUpdateManagerDelegate, UIAlertViewDelegate>

/**
 Creates a new instance of this bridge configuration view controller.
 @param delegate the delegate to inform when the config is saved
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHBridgeConfigurationViewControllerDelegate>)delegate;

@end
