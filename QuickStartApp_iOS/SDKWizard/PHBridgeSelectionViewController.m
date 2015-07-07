/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHBridgeSelectionViewController.h"
#import "PHAppDelegate.h"

@interface PHBridgeSelectionViewController ()

@end

@implementation PHBridgeSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bridges:(NSDictionary *)bridges delegate:(id<PHBridgeSelectionViewControllerDelegate>)delegate {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Make it a form on iPad
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        self.delegate = delegate;
        self.bridgesFound = bridges;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set title of screen
    self.title = @"Available SmartBridges";
    
    // Refresh button
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                             target:self
                                             action:@selector(refreshButtonClicked:)];
	self.navigationItem.rightBarButtonItem = refreshBarButtonItem;
}

- (IBAction)refreshButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [UIAppDelegate searchForBridgeLocal];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bridgesFound.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Sort bridges by bridge id
    NSArray *sortedKeys = [self.bridgesFound.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    // Get mac address and ip address of selected bridge
    NSString *bridgeId = [sortedKeys objectAtIndex:indexPath.row];
    NSString *ip = [self.bridgesFound objectForKey:bridgeId];
    
    // Update cell
    cell.textLabel.text = bridgeId;
    cell.detailTextLabel.text = ip;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Please select a SmartBridge to use for this application";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Sort bridges by bridge id
    NSArray *sortedKeys = [self.bridgesFound.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    /***************************************************
     The choice of bridge to use is made, store the bridge id
     and ip address for this bridge
     *****************************************************/
    
    // Get bridge id and ip address of selected bridge
    NSString *bridgeId = [sortedKeys objectAtIndex:indexPath.row];
    NSString *ip = [self.bridgesFound objectForKey:bridgeId];
    
    // Inform delegate
    [self.delegate bridgeSelectedWithIpAddress:ip andBridgeId:bridgeId];
}

@end
