/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHLightsViewController.h"
#import "PHLightOverviewViewController.h"
#import "PHLightControlSelectionViewController.h"

@interface PHLightsViewController ()

@end

@implementation PHLightsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Lights", @"");
    
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Light overview
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Overview", @"Overview of the lights");
    }
    // Light control
    else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"Control", @"Control a light");        
    }
    // Light renaming and searching are part of the SDK wizard
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PHLightOverviewViewController *lightOverviewViewController = [[PHLightOverviewViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
        [self.navigationController pushViewController:lightOverviewViewController animated:YES];
    }
    else if (indexPath.row == 1) {
        PHLightControlSelectionViewController *lightSelectionViewController = [[PHLightControlSelectionViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
        [self.navigationController pushViewController:lightSelectionViewController animated:YES];
    }
}

@end
