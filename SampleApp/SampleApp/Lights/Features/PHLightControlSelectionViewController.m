/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHLightControlSelectionViewController.h"
#import "PHLightControlViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHLightControlSelectionViewController ()

@property (strong, nonatomic) NSArray *lights;

@end

@implementation PHLightControlSelectionViewController

@synthesize lights = _lights;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self updateLights];
    }
    return self;
}

- (void)dealloc {
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Light selection", @"");
    
    self.clearsSelectionOnViewWillAppear = YES;

    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(updateLights) forNotification:LIGHTS_CACHE_UPDATED_NOTIFICATION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    PHLight *light = [self.lights objectAtIndex:indexPath.row];
    
    // Show light name and identifier
    cell.textLabel.text = light.name;
    cell.detailTextLabel.text = light.identifier;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHLight *light = [self.lights objectAtIndex:indexPath.row];
    
    PHLightControlViewController *lightControlViewController = [[PHLightControlViewController alloc] initWithNibName:@"PHLightControlViewController" bundle:nil andLight:light];
    [self.navigationController pushViewController:lightControlViewController animated:YES];
}

#pragma mark - Notification receivers

- (void)updateLights {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    self.lights = [cache.lights.allValues sortedArrayUsingComparator:^NSComparisonResult(PHLight *light1, PHLight *light2) {
        return [light1.identifier compare:light2.identifier options:NSNumericSearch];
    }];
    
    [self.tableView reloadData];
}

@end
