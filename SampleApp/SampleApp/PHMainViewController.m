/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHMainViewController.h"
#import "PHLightsViewController.h"
#import "PHGroupsViewController.h"
#import "PHSchedulesViewController.h"
#import "PHAppDelegate.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHMainViewController ()

@property (assign, nonatomic) BOOL logging;

@end

@implementation PHMainViewController

@synthesize logging = _logging;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.title = NSLocalizedString(@"Sample app", @"");
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    // Register for the local heartbeat notifications
    [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
  
    // Bridge info
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // IP address
        if (indexPath.row == 0) {
            PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
            
            cell.textLabel.text = NSLocalizedString(@"IP address", @"");
            // Set the ip address of the bridge
            cell.detailTextLabel.text = cache.bridgeConfiguration.ipaddress;
        }
        // Last heartbeat
        else if (indexPath.row == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"Last heartbeat", @"");
            
            if (UIAppDelegate.phHueSDK.localConnected) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterNoStyle];
                [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
                
                // Set current time as last successful heartbeat time
                cell.detailTextLabel.text = [dateFormatter stringFromDate:[NSDate date]];
            }
            else {
                cell.detailTextLabel.text = NSLocalizedString(@"no connection", @"");
            }
        }
    }
    // SDK domain objects
    else if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Lights
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Lights", @"Overview of the features for lights");
        }
        // Groups
        else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Groups", @"Overview of the features for groups");
        }
        // Schedules
        else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Schedules", @"Overview of the features for schedules");
        }
    }
    // Brdige config
    else if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = NSLocalizedString(@"Bridge config", @"Overview of the bridge configuration");
    }
    // Other options
    else if (indexPath.section == 3) {
        // Logging
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = NSLocalizedString(@"Logging", @"Switching logging on/off");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwitch *loggingSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            loggingSwitch.on = self.logging;
            [loggingSwitch addTarget:self action:@selector(loggingSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = loggingSwitch;
        }
        else if (indexPath.row == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = NSLocalizedString(@"Show responses", @"Show responses on/off");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwitch *showResponsesSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            showResponsesSwitch.on = UIAppDelegate.showResponses;
            [showResponsesSwitch addTarget:self action:@selector(showResponsesSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            
            cell.accessoryView = showResponsesSwitch;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            PHLightsViewController *lightsViewController = [[PHLightsViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
            [self.navigationController pushViewController:lightsViewController animated:YES];
        }
        else if (indexPath.row == 1) {
            PHGroupsViewController *groupsViewController = [[PHGroupsViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
            [self.navigationController pushViewController:groupsViewController animated:YES];
        }
        else if (indexPath.row == 2) {
            PHSchedulesViewController *schedulesViewController = [[PHSchedulesViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
            [self.navigationController pushViewController:schedulesViewController animated:YES];
        }
    }
    else if (indexPath.section == 2) {
        PHConfigurationViewController *configViewController = [[PHConfigurationViewController alloc] initWithNibName:@"PHConfigurationViewController" bundle:[NSBundle mainBundle] hueSDK:UIAppDelegate.phHueSDK delegate:self];
        
        UINavigationController *configNavController = [[UINavigationController alloc] initWithRootViewController:configViewController];
        configNavController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self.navigationController presentViewController:configNavController animated:YES completion:nil];
    }
}

#pragma mark - Switches

- (void)loggingSwitchChanged:(id)sender {
    UISwitch *loggingSwitch = (UISwitch *)sender;
    
    self.logging = [loggingSwitch isOn];
    
    [UIAppDelegate.phHueSDK enableLogging:self.logging];
}

- (void)showResponsesSwitchChanged:(id)sender {
    UISwitch *showResponsesSwitch = (UISwitch *)sender;
    
    UIAppDelegate.showResponses = [showResponsesSwitch isOn];
}

#pragma mark - Configuration view controller delegate

- (void)closeConfigurationView:(PHConfigurationViewController *)configurationView {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)startSearchForBridge:(PHConfigurationViewController *)configurationView {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    [UIAppDelegate searchForBridgeLocal];
}

#pragma mark - Notification receivers

- (void)localConnection {
    [self.tableView reloadData];
}

- (void)noLocalConnection {
    [self.tableView reloadData];
}

@end
