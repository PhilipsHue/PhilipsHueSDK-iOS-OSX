/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import "PHBridgeConfigurationViewController.h"
#import "PHFindLightsResultViewController.h"

@class PHHueSDK;
@class PHConfigurationViewController;

@protocol PHConfigurationViewControllerDelegate <NSObject, UITextFieldDelegate>

/**
 This method is called when the done button on the configuration screen is tapped.
 @param configurationView The configuration view that called this method
 */
- (void)closeConfigurationView:(PHConfigurationViewController *)configurationView;

/**
 This method is called when a bridge search should be started
 @param configurationView The configuration view that called this method
 */
- (void)startSearchForBridge:(PHConfigurationViewController *)configurationView;

@end

/**
 This is the hue configuration sdk wizard. You can plug this viewcontroller into your application
 to allow changing of settings from your app. You should change this class
 to include memory management if you are not using ARC.
 */
@interface PHConfigurationViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate, PHBridgeConfigurationViewControllerDelegate, PHFindLightsDelegate>

/**
 Creates a configuration view controller
 @param hueSDK the PHHueSDK instance to use
 @param delegate the delegate object
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil hueSDK:(PHHueSDK *)hueSDK delegate:(id<PHConfigurationViewControllerDelegate>)delegate;

@end
