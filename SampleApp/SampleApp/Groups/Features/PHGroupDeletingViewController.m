/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHAppDelegate.h"
#import "PHGroupDeletingViewController.h"

#include <HueSDK_iOS/HueSDK.h>

@interface PHGroupDeletingViewController ()

@property (strong, nonatomic) NSArray *groups;

@end

@implementation PHGroupDeletingViewController

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
    
    self.title = NSLocalizedString(@"Delete group", @"");
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Set the tableview in editing mode
    self.tableView.editing = YES;
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PHGroup *group = [self.groups objectAtIndex:indexPath.row];
    
    // Show group name
    cell.textLabel.text = group.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
        
        PHGroup *group = [self.groups objectAtIndex:indexPath.row];
        
        // Delete the group
        [bridgeSendAPI removeGroupWithId:group.identifier completionHandler:^(NSArray *errors) {
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

- (void)updateGroups {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    self.groups = [cache.groups.allValues sortedArrayUsingComparator:^NSComparisonResult(PHGroup *group1, PHGroup *group2) {
        return [group1.identifier compare:group2.identifier options:NSNumericSearch];
    }];
    
    [self.tableView reloadData];
}

@end