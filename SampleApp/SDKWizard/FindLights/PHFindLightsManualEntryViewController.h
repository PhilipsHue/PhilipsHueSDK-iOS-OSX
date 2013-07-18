/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>
#import "PHFindLightsStartViewController.h"

@interface PHFindLightsManualEntryViewController : UITableViewController <UIAlertViewDelegate, UITextFieldDelegate>

/**
 Creates a new instance of this find lights view controller.
 @param delegate the delegate to inform when the search is done
 @param previousResults the previous results which should still be shown
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHFindLightsDelegate>)delegate previousResults:(NSDictionary *)previousResults;

@end
