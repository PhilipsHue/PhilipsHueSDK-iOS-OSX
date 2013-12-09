/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHScheduleEditingSelectionViewController.h"
#import "PHScheduleEditingViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHScheduleEditingSelectionViewController ()

@property (strong, nonatomic) NSArray *schedules;

@end

@implementation PHScheduleEditingSelectionViewController

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
    
    self.title = NSLocalizedString(@"Schedule selection", @"");
    
    self.clearsSelectionOnViewWillAppear = YES;
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    PHSchedule *schedule = [self.schedules objectAtIndex:indexPath.row];
    
    // Show schedule name and identifier
    cell.textLabel.text = schedule.name;
    cell.detailTextLabel.text = schedule.identifier;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHSchedule *schedule = [self.schedules objectAtIndex:indexPath.row];
    
    PHScheduleEditingViewController *scheduleEditingViewController = [[PHScheduleEditingViewController alloc] initWithNibName:@"PHScheduleEditingViewController" bundle:nil andSchedule:schedule];
    [self.navigationController pushViewController:scheduleEditingViewController animated:YES];
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
