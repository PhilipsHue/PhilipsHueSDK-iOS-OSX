/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

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
 @param lightSerials the serials of lights to search for (lights which are factory new will be found even if not in this list)
 @param previousResults the previous results which should still be shown
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHFindLightsDelegate>)delegate lightSerials:(NSArray *)lightSerials previousResults:(NSDictionary *)previousResults;

/**
 Starts the search for new lights
 */
- (void)startSearch;

@end
