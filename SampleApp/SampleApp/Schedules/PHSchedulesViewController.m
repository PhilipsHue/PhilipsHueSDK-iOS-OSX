/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSchedulesViewController.h"
#import "PHScheduleOverviewViewController.h"
#import "PHScheduleAddingViewController.h"
#import "PHScheduleEditingSelectionViewController.h"
#import "PHScheduleDeletingViewController.h"

@interface PHSchedulesViewController ()

@end

@implementation PHSchedulesViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Schedules", @"");
    
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Schedule overview
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Overview", @"Overview of the schedules");
    }
    // Add a schedule
    else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"Add", @"Add a schedule");
    }
    // Edit a schedule
    else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"Edit", @"Edit a schedule");
    }
    // Delete a schedule
    else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"Delete", @"Delete a schedule");
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PHScheduleOverviewViewController *scheduleOverviewViewController = [[PHScheduleOverviewViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
        [self.navigationController pushViewController:scheduleOverviewViewController animated:YES];
    }
    else if (indexPath.row == 1) {
        PHScheduleAddingViewController *scheduleAddingViewController = [[PHScheduleAddingViewController alloc] init];
        [self.navigationController pushViewController:scheduleAddingViewController animated:YES];
    }
    else if (indexPath.row == 2) {
        PHScheduleEditingSelectionViewController *scheduleEditingSelectionViewController = [[PHScheduleEditingSelectionViewController alloc] init];
        [self.navigationController pushViewController:scheduleEditingSelectionViewController animated:YES];
    }
    else if (indexPath.row == 3) {
        PHScheduleDeletingViewController *scheduleDeletingViewController = [[PHScheduleDeletingViewController alloc] init];
        [self.navigationController pushViewController:scheduleDeletingViewController animated:YES];
    }
}

@end
