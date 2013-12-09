/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHAppDelegate.h"
#import "PHScheduleDeletingViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHScheduleDeletingViewController ()

@property (strong, nonatomic) NSArray *schedules;

@end

@implementation PHScheduleDeletingViewController

@synthesize schedules = _schedules;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self updateSchedules];
    }
    return self;
}

- (void)dealloc {
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Delete schedule", @"");
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Set the tableview in editing mode
    self.tableView.editing = YES;
    
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(updateSchedules) forNotification:SCHEDULES_CACHE_UPDATED_NOTIFICATION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schedules.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PHSchedule *schedule = [self.schedules objectAtIndex:indexPath.row];
    
    // Show schedule name
    cell.textLabel.text = schedule.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
        
        PHSchedule *schedule = [self.schedules objectAtIndex:indexPath.row];
        
        // Delete the schedule
        [bridgeSendAPI removeScheduleWithId:schedule.identifier completionHandler:^(NSArray *errors) {
            if (UIAppDelegate.showResponses || errors != nil) {
                NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Response", @"")
                                                                     message:message
                                                                    delegate:nil
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:NSLocalizedString(@"Ok", @""), nil];
                [errorAlert show];
            }
        }];
    }
}

#pragma mark - Notification receivers

- (void)updateSchedules {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    self.schedules = [cache.schedules.allValues sortedArrayUsingComparator:^NSComparisonResult(PHSchedule *schedule1, PHSchedule *schedule2) {
        return [schedule1.identifier compare:schedule2.identifier options:NSNumericSearch];
    }];
    
    [self.tableView reloadData];
}

@end
