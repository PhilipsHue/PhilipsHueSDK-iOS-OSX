/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHGroupsViewController.h"
#import "PHGroupOverviewViewController.h"
#import "PHGroupControlSelectionViewController.h"
#import "PHGroupAddingViewController.h"
#import "PHGroupEditingViewController.h"
#import "PHGroupDeletingViewController.h"

@interface PHGroupsViewController ()

@end

@implementation PHGroupsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Groups", @"");
    
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Group overview
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Overview", @"Overview of the groups");
    }
    // Group control
    else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"Control", @"Control a group");
    }
    // Add a group
    else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"Add", @"Add a group");
    }
    // Edit a group
    else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"Edit", @"Edit a group");
    }
    // Delete a group
    else if (indexPath.row == 4) {
        cell.textLabel.text = NSLocalizedString(@"Delete", @"Delete a group");
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PHGroupOverviewViewController *groupOverviewViewController = [[PHGroupOverviewViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
        [self.navigationController pushViewController:groupOverviewViewController animated:YES];
    }
    else if (indexPath.row == 1) {
        PHGroupControlSelectionViewController *groupControlSelectionViewController = [[PHGroupControlSelectionViewController alloc] init];
        [self.navigationController pushViewController:groupControlSelectionViewController animated:YES];
    }
    else if (indexPath.row == 2) {
        PHGroupAddingViewController *groupAddingViewController = [[PHGroupAddingViewController alloc] init];
        [self.navigationController pushViewController:groupAddingViewController animated:YES];
    }
    else if (indexPath.row == 3) {
        PHGroupEditingViewController *groupEditingViewController = [[PHGroupEditingViewController alloc] init];
        [self.navigationController pushViewController:groupEditingViewController animated:YES];
    }
    else if (indexPath.row == 4) {
        PHGroupDeletingViewController *groupDeletingViewController = [[PHGroupDeletingViewController alloc] init];
        [self.navigationController pushViewController:groupDeletingViewController animated:YES];
    }
}

@end
