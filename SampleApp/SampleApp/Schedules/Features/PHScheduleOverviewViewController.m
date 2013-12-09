/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHScheduleOverviewViewController.h"

#include <HueSDK_iOS/HueSDK.h>

@interface PHScheduleOverviewViewController ()

@property (strong, nonatomic) NSArray *schedules;

@end

@implementation PHScheduleOverviewViewController

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
    
    self.title = NSLocalizedString(@"Schedule overview", @"");
    
    self.clearsSelectionOnViewWillAppear = NO;
    
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    // Show schedule date
    cell.detailTextLabel.text = [dateFormatter stringFromDate:schedule.date];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
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
