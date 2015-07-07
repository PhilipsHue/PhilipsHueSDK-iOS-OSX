/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHBridgeSelectionViewController.h"
#import <HueSDK_OSX/HueSDK.h>
#import "AppDelegate.h"

@interface PHBridgeSelectionViewController ()

@property (nonatomic,strong) NSDictionary *bridgesFound;
@property (nonatomic,strong) NSArray *sortedBridgeKeys;

@property (nonatomic,weak) IBOutlet NSTableView *tableView;
@property (nonatomic,weak) IBOutlet NSButton *connectButton;
@property (nonatomic,weak) IBOutlet NSButton *searchButton;

@end

@implementation PHBridgeSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bridges:(NSDictionary *)bridges delegate:(id<PHBridgeSelectionViewControllerDelegate>)delegate {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = delegate;
        self.bridgesFound = bridges;
        
        // Sort bridges by mac address
        self.sortedBridgeKeys = [self.bridgesFound.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    [self.connectButton setEnabled:NO];
}

- (IBAction)refreshButtonClicked:(id)sender {
    // remove this sheet
    [NSAppDelegate searchForBridgeLocal];
}

- (IBAction)connectButtonClicked:(id)sender{
    if ([self.tableView selectedRow]>-1){
        /***************************************************
         The choice of bridge to use is made, store the bridge id
         and ip address for this bridge
         *****************************************************/
    
        // Get bridge id and ip address of selected bridge
        NSString *bridgeId = [self.sortedBridgeKeys objectAtIndex:[self.tableView selectedRow]];
        NSString *ip = [self.bridgesFound objectForKey:bridgeId];
        
        // Inform delegate
        [self.delegate bridgeSelectedWithIpAddress:ip andBridgeId:bridgeId];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.bridgesFound.allKeys count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // Get a new ViewCell
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    // Get mac address and ip address of selected bridge
    NSString *mac = [self.sortedBridgeKeys objectAtIndex:row];
    NSString *ip = [self.bridgesFound objectForKey:mac];
    
    if ([tableColumn.identifier isEqualToString:@"FirstColumn"]){
        cellView.textField.stringValue = mac;
    } else if ([tableColumn.identifier isEqualToString:@"SecondColumn"]){
        cellView.textField.stringValue = ip;
    }
    
    return cellView;
}

#pragma mark - Table view delegate

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    if ([self.tableView selectedRow]>-1){
        [self.connectButton setEnabled:YES];
    } else {
        [self.connectButton setEnabled:NO];
    }
}

@end
