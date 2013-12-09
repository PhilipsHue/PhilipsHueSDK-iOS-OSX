/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHAppDelegate.h"
#import "PHGroupEditingViewController.h"

#include <HueSDK_iOS/HueSDK.h>

@interface PHGroupEditingViewController ()

@property (strong, nonatomic) NSArray *groups;

@end

@implementation PHGroupEditingViewController

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
    
    self.title = NSLocalizedString(@"Edit group", @"");
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(updateGroups) forNotification:GROUPS_CACHE_UPDATED_NOTIFICATION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)nameTextFieldEditingEnd:(id)sender {
    UITextField *nameTextField = (UITextField *)sender;
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    
    PHGroup *group = [cache.groups objectForKey:[NSString stringWithFormat:@"%d", nameTextField.tag]];
    
    // Check if the name has been changed
    if (![group.name isEqualToString:nameTextField.text]) {
        // Update the name in the group
        group.name = nameTextField.text;
        
        id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
        
        // Update the group
        [bridgeSendAPI updateGroupWithGroup:group completionHandler:^(NSArray *errors) {
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
    
    // Show text field which contains the group name
    UITextField *nameTextField = [[UITextField alloc] init];
    nameTextField.text = group.name;
    nameTextField.delegate = self;
    nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTextField.font = [UIFont systemFontOfSize:16];
    nameTextField.textColor = [UIColor blueColor];
    nameTextField.bounds = CGRectMake(0, 0, 150, 20);
    nameTextField.textAlignment = NSTextAlignmentRight;
    nameTextField.backgroundColor = [UIColor clearColor];
    // Use the group identifier as identifier for the text field
    nameTextField.tag = [group.identifier intValue];
    // Add event when the editing ends the group name will be updated
    [nameTextField addTarget:self action:@selector(nameTextFieldEditingEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    cell.textLabel.text = NSLocalizedString(@"Name", @"");
    cell.accessoryView = nameTextField;
    
    return cell;
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Close keyboard after editing a text field
    [textField resignFirstResponder];
    return YES;
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
