/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHFindLightsResultViewController.h"
#import "PHFindLightsManualEntryViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHFindLightsResultViewController ()

/**
 The delegate
 */
@property (nonatomic, strong) id<PHFindLightsDelegate> delegate;

/**
 The repeated interval timer, updating the list of lights found by the bridge
 */
@property (nonatomic, strong) NSTimer *intervalTimer;

/**
 The timeouttimer, keeping track of the overall search time
 */
@property (nonatomic, strong) NSTimer *timeoutTimer;

/**
 A local cache of the lights found by the bridge
 */
@property (nonatomic, strong) NSMutableDictionary *lightsFound;

/**
 Boolean indicating if the search is complete
 */
@property (nonatomic, assign) BOOL searchDone;

/**
 The specific light serials to search for (can be nil)
 */
@property (nonatomic, strong) NSArray *lightSerials;

@end

@implementation PHFindLightsResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHFindLightsDelegate>)delegate lightSerials:(NSArray *)lightSerials previousResults:(NSDictionary *)previousResults {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Make it a form on iPad
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        // Set delegate object to use
        self.delegate = delegate;
        
        // Set light serials
        self.lightSerials = lightSerials;
        
        // Set previous results
        self.lightsFound = [NSMutableDictionary dictionary];
        [self.lightsFound addEntriesFromDictionary:previousResults];
        
        // Set title
        self.title = NSLocalizedString(@"Find new lights", @"Find new lights screen title");
        
        // Remove back button from navigation bar
        [self.navigationItem setHidesBackButton:YES];
    }
    return self;
}

- (void)dealloc {
    [self stopTimers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setProgressView:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
}

/**
 Starts the actual search for lights
 */
- (void)startSearch {
    // Disable display sleep
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // Register for connection loss notifications
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(stopTimers) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(stopTimers) forNotification:NO_LOCAL_AUTHENTICATION_NOTIFICATION];
    
    // Invoke the search command
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    PHBridgeSendErrorArrayCompletionHandler completionHandler = ^(NSArray *errors) {
        if (!errors) {
            // No errors, start timers
            self.intervalTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLightsFound) userInfo:nil repeats:YES];
            self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(finishSearch) userInfo:nil repeats:NO];
        }
        else {
            // Error, stop search
            [self finishSearch];
        }
    };
    
    if (![[PHBridgeResourcesReader readBridgeResourcesCache].bridgeConfiguration.swversion isEqualToString:@"01003542"] &&
        self.lightSerials != nil && self.lightSerials.count > 0) {
        [bridgeSendAPI searchForNewLightsWithSerials:self.lightSerials completionHandler:completionHandler];
    }
    else {
        [bridgeSendAPI searchForNewLights:completionHandler];
    }
}

/**
 Stops the timers
 */
- (void)stopTimers {
    // Deregister for notifications
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
    
    if (self.intervalTimer) {
        [self.intervalTimer invalidate];
        self.intervalTimer = nil;
    }
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
}

/**
 Method invoked by timer to get the new found lights from the bridge and update the interface
 */
- (void)updateLightsFound {
    // Calculate remaining time / progress
    NSTimeInterval remainingTime = [[self.timeoutTimer fireDate] timeIntervalSinceNow];
    float percentageRemaining = 100.0f - remainingTime / 60.0f * 100;
    self.progressView.progress = (percentageRemaining / 100.0f);
    
    // Get the lights from the bridge
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    [bridgeSendAPI getNewFoundLights:^(NSDictionary *dictionary, NSString *lastScan, NSArray *errors) {
        if (dictionary != nil && dictionary.count > 0) {
            // Results were found, reload table
            [self.lightsFound addEntriesFromDictionary:dictionary];
            [self.tableView reloadData];
        }
    }];
}

/**
 Called by timer when search is done
 */
- (void)finishSearch {
    // Stop timers
    if (self.intervalTimer) {
        [self.intervalTimer invalidate];
        self.intervalTimer = nil;
    }
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
        self.timeoutTimer = nil;
    }
    
    // Update table
    self.searchDone = YES;
    [self.tableView reloadData];
    
    // Enable display sleep again
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    // Add done button to navigation bar
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)] animated:YES];
    
    // Update toolbar to done message
    UIBarButtonItem *flexItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *flexItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    NSString *searchDoneText = NSLocalizedString(@"Search done", @"Light search done text");
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    CGSize textSize = [searchDoneText sizeWithFont:font];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
    [titleLabel setFont:font];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [UIColor darkTextColor] : [UIColor colorWithWhite:1.0f alpha:1.0f]];
    [titleLabel setText:searchDoneText];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:flexItem1, titleItem, flexItem2, nil];
    [self.toolbar setItems:toolbarItems animated:YES];
    
    [self.tableView reloadData];
}

/**
 Invoked by a press on the done button
 */
- (void)doneButton {
    // Instruct delegate to close the screen
    [self.delegate lightsSearchDone];
}

#pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![[PHBridgeResourcesReader readBridgeResourcesCache].bridgeConfiguration.swversion isEqualToString:@"01003542"] && self.searchDone) {
        // We have a new bridge -> give option to remote reset a light when search is done
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check if we have lights to show
    if (section == 0) {
        if (self.lightsFound.count > 0) {
            return self.lightsFound.count;
        }
        
        // We show a message in the table when no lights are found (yet)
        return 1;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create table view cell
    if (indexPath.section == 0) {
        // Light cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultcell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultcell"];
        }
        
        // Check if we already have results
        if (self.lightsFound.count > 0) {
            // Order by identifier
            NSArray *lightKeys = [self.lightsFound.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            NSString *lightName = [self.lightsFound objectForKey:[lightKeys objectAtIndex:indexPath.row]];
            
            cell.textLabel.text = lightName;
        }
        else {
            // Show default message
            if (!self.searchDone) {
                // Still searching
                cell.textLabel.text = NSLocalizedString(@"No new lights found yet", @"No lights found yet message");
            }
            else {
                // Search done
                cell.textLabel.text = NSLocalizedString(@"No new lights found", @"No lights found message");
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        // Find more lights button
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findmorecell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"findmorecell"];
        }
        
        cell.textLabel.text = NSLocalizedString(@"Add lights manually", @"Add lights manually button");
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Lights found:", @"Lights found message above results table");
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        // Add manually button
        PHFindLightsManualEntryViewController *findLightsController = [[PHFindLightsManualEntryViewController alloc] initWithNibName:@"PHFindLightsManualEntryViewController" bundle:[NSBundle mainBundle] delegate:self.delegate previousResults:self.lightsFound];
        [self.navigationController pushViewController:findLightsController animated:YES];
    }
}

@end
