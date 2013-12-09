/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import <HueSDK_iOS/HueSDK.h>
#import "PHConfigurationViewController.h"

@interface PHMainViewController : UITableViewController <UITextFieldDelegate, PHConfigurationViewControllerDelegate>

- (id)initWithStyle:(UITableViewStyle)style;

@end
