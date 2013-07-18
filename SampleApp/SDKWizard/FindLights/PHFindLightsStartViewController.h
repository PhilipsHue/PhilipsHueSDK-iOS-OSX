/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>

#import "PHFindLightsResultViewController.h"

/**
 This is the lights search explanation sdk wizard. You can plug this viewcontroller into your application
 to allow a lights search in your app. You should change this class
 to include memory management if you are not using ARC.
 */
@interface PHFindLightsStartViewController : UIViewController

/**
 Creates a new instance of this find lights view controller.
 @param delegate the delegate to inform when the search is done
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHFindLightsDelegate>)delegate;

/**
 Method for the start search button
 */
- (IBAction)startSearch:(id)sender;

@end
