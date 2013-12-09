/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHLightOverviewViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHLightOverviewViewController ()

@property (strong, nonatomic) NSArray *lights;

@end

@implementation PHLightOverviewViewController

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

    self.title = NSLocalizedString(@"Light overview", @"");
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    /***************************************************
     Each bridge resource has a notification when it has been
     updated. Here we register for the lights cache updated
     notification
     *****************************************************/
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    PHLight *light = [self.lights objectAtIndex:indexPath.row];
    
    // Show light name
    cell.textLabel.text = light.name;
    
    // Show the color of the light if turned on
    if (light.supportsColor && [light.lightState.on boolValue]) {
        UIView* colorView = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 80, (cell.frame.size.height - 35) / 2, 40, 35)];
        
        // Convert the xy values to rgb values
        colorView.backgroundColor = [PHUtilities colorFromXY:CGPointMake([light.lightState.x floatValue], [light.lightState.y floatValue]) forModel:light.modelNumber];
        [cell.contentView addSubview:colorView];
    }
    
    return cell;
}

#pragma mark - Notification receivers

- (void)updateLights {
    /***************************************************
     The notification of changes to the lights information
     in the Bridge resources cache called this method.
     Now we access Bridge resources cache to get updated
     information and reload the displayed lights table.
     *****************************************************/
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];

    self.lights = [cache.lights.allValues sortedArrayUsingComparator:^NSComparisonResult(PHLight *light1, PHLight *light2) {
        return [light1.identifier compare:light2.identifier options:NSNumericSearch];
    }];
    
    [self.tableView reloadData];
}

@end
