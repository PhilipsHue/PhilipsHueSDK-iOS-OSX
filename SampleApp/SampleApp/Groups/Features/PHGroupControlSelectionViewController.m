/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHGroupControlSelectionViewController.h"
#import "PHGroupControlViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHGroupControlSelectionViewController ()

@property (strong, nonatomic) NSArray *groups;

@end

@implementation PHGroupControlSelectionViewController

@synthesize groups = _groups;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self updateGroups];
    }
    return self;
}

- (void)dealloc {
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Group selection", @"");
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(updateGroups) forNotification:GROUPS_CACHE_UPDATED_NOTIFICATION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    PHGroup *group = [self.groups objectAtIndex:indexPath.row];
    
    // Show group name and identifier
    cell.textLabel.text = group.name;
    cell.detailTextLabel.text = group.identifier;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHGroup *group = [self.groups objectAtIndex:indexPath.row];
    
    PHGroupControlViewController *groupControlViewController = [[PHGroupControlViewController alloc] initWithNibName:@"PHGroupControlViewController" bundle:nil andGroup:group];
    [self.navigationController pushViewController:groupControlViewController animated:YES];
}

#pragma mark - Notification receivers

- (void)updateGroups {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    self.groups = [cache.groups.allValues sortedArrayUsingComparator:^NSComparisonResult(PHGroup *group1, PHGroup *group2) {
        return [group1.identifier compare:group2.identifier options:NSNumericSearch];
    }];
    
    [self.tableView reloadData];
}

@end
