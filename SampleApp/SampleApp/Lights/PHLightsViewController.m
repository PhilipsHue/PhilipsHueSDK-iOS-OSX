//
//  PHLightsViewController.m
//  SDK3rdApp
//
//  Copyright (c) 2012 Philips. All rights reserved.
//

#import "PHLightsViewController.h"
#import "PHLightViewController.h"

#import <HueSDK/SDK.h>

@interface PHLightsViewController ()

@end

@implementation PHLightsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self updateLights];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set title of this view
    self.title = @"Lights";
    /***************************************************
     Each bridge resource has a notification when it has been 
     updated. Here we register for the lights cache updated 
     notification
     *****************************************************/

    
    // Add notification listener for cache update of lights
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(updateLights) forNotification:LIGHTS_CACHE_UPDATED_NOTIFICATION];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Gets the list of lights from the cache and updates the tableview
 */
- (void)updateLights {
    /***************************************************
     The notification of changes to the lights information
     in the Bridge resources cache called this method.
     Now we access Bridge resources cache to get updated
     information and reload the displayed lights table.
     *****************************************************/

    // Gets lights from cache
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    self.lights = cache.lights;
    
    // Update tableview based on new lights
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.lights.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Sort the light identifiers, so they are always shown in correct order
    NSArray *sortedKeys = [self.lights.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    // Get light
    PHLight *light = [self.lights objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    
    // Update cell with light information
    cell.textLabel.text = light.name;
    cell.detailTextLabel.text = light.identifier;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Sort the light identifiers, so you get the correct light identifier
    NSArray *sortedKeys = [self.lights.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    /***************************************************
     The user has selected a light, prepare the PHLightViewController
     for that light and push it onto display
     *****************************************************/
    
    // Get light
    PHLight *light = [self.lights objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    
    // Create new view controller for displaying light
    PHLightViewController *lightViewController = [[PHLightViewController alloc] initWithNibName:@"PHLightViewController" bundle:nil light:light];
    [self.navigationController pushViewController:lightViewController animated:YES];
}

@end
