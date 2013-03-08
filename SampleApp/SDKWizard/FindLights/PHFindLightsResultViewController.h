//
//  PHFindLightsResultViewController.h
//  SampleApp
//
//  Copyright (c) 2012 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PHFindLightsDelegate <NSObject>

/**
 Invoked when the searching for lights is done and the view should be removed.
 */
- (void)lightsSearchDone;

@end

/**
 This is the lights search results sdk wizard. You can plug this viewcontroller into your application
 to allow a lights search in your app. You should change this class
 to include memory management if you are not using ARC.
 */
@interface PHFindLightsResultViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

/**
 Creates a new instance of this find lights view controller.
 @param delegate the delegate to inform when the search is done
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHFindLightsDelegate>)delegate;

/**
 Starts the search for new lights
 */
- (void)startSearch;

@end
