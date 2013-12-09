/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHBridgeConfigurationViewController.h"
#import "PHLoadingViewController.h"

#import <HueSDK_iOS/HueSDK.h>

@interface PHBridgeConfigurationViewController ()

/**
 The delegate object
 */
@property (nonatomic, unsafe_unretained) id<PHBridgeConfigurationViewControllerDelegate> delegate;

/**
 The loading view, shown when saving a new name
 */
@property (nonatomic, strong) PHLoadingViewController *loadingView;

/**
 The switch to enable or disable DHCP
 */
@property (nonatomic, strong) UISwitch *dhcpSwitch;

/**
 The switch to enable or disable proxy
 */
@property (nonatomic, strong) UISwitch *proxySwitch;

/**
 The textfield to change the name
 */
@property (nonatomic, strong) UITextField *nameLabel;

/**
 The textfield to change the ipaddress
 */
@property (nonatomic, strong) UITextField *ipAddressLabel;

/**
 The textfield to change the netmask
 */
@property (nonatomic, strong) UITextField *netmaskLabel;

/**
 The textfield to change the gateway
 */
@property (nonatomic, strong) UITextField *gatewayLabel;

/**
 The textfield to change the proxy address
 */
@property (nonatomic, strong) UITextField *proxyAddressLabel;

/**
 The textfield to change the proxy port
 */
@property (nonatomic, strong) UITextField *proxyPortLabel;

/**
 The alert shown when an invalid bridge name is entered
 */
@property (nonatomic, strong) UIAlertView *invalidNameAlert;

/**
 The alert shown when the configuration could not be saved
 */
@property (nonatomic, strong) UIAlertView *saveErrorAlert;

/**
 The software update manager to check for update status
 */
@property (nonatomic, strong) PHSoftwareUpdateManager *updateManager;

@end

@implementation PHBridgeConfigurationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHBridgeConfigurationViewControllerDelegate>)delegate {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Make it a form on iPad
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"My Bridge", @"My bridge button in configuration screen");
    
    // Create save button
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(saveButton:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Update the interface with current bridge settings
    [self updateValues];
    
    // Register for notifications of connection loss
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(connectionLost) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
}

- (void)dealloc {
    // Deregister for notifications
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
    
    if (self.updateManager != nil) {
        [self.updateManager cancelCheck];
    }
}

/**
 Closes popups on connection loss.
 */
- (void)connectionLost {
    // Connection lost, close rename popup when active
    if (self.invalidNameAlert != nil) {
        [self.invalidNameAlert dismissWithClickedButtonIndex:self.invalidNameAlert.cancelButtonIndex animated:YES];
    }
    if (self.saveErrorAlert != nil) {
        [self.saveErrorAlert dismissWithClickedButtonIndex:self.saveErrorAlert.cancelButtonIndex animated:YES];
    }
}

/**
 Gets the current bridge configuration from the cache of the SDK and updates the interface to those settings.
 */
- (void)updateValues {
    PHBridgeConfiguration *bridgeConfig = [[PHBridgeResourcesReader readBridgeResourcesCache] bridgeConfiguration];
    
    // Set name
    UITextField *nameLabel = [[UITextField alloc] init];
    self.nameLabel = nameLabel;
    self.nameLabel.text = bridgeConfig.name;
    self.nameLabel.delegate = self;
    self.nameLabel.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Set ipaddress
    UITextField *ipAddressLabel = [[UITextField alloc] init];
    self.ipAddressLabel = ipAddressLabel;
    self.ipAddressLabel.text = bridgeConfig.ipaddress;
    self.ipAddressLabel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.ipAddressLabel.delegate = self;
    
    // Set netmask
    UITextField *netmaskLabel = [[UITextField alloc] init];
    self.netmaskLabel = netmaskLabel;
    self.netmaskLabel.text = bridgeConfig.netmask;
    self.netmaskLabel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.netmaskLabel.delegate = self;
    
    // Set gateway
    UITextField *gatewayLabel = [[UITextField alloc] init];
    self.gatewayLabel = gatewayLabel;
    self.gatewayLabel.text = bridgeConfig.gateway;
    self.gatewayLabel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.gatewayLabel.delegate = self;
    
    // Set proxyaddress
    UITextField *proxyAddressLabel = [[UITextField alloc] init];
    self.proxyAddressLabel = proxyAddressLabel;
    self.proxyAddressLabel.text = bridgeConfig.proxyAddress;
    self.proxyAddressLabel.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.proxyAddressLabel.delegate = self;
    self.proxyAddressLabel.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Set proxyport
    UITextField *proxyPortLabel = [[UITextField alloc] init];
    self.proxyPortLabel = proxyPortLabel;
    self.proxyPortLabel.text = [NSString stringWithFormat:@"%d", bridgeConfig.proxyPort.intValue];
    self.proxyPortLabel.keyboardType = UIKeyboardTypeNumberPad;
    self.proxyPortLabel.delegate = self;
    
    // Set dhcp enabled or disabled
    UISwitch *dhcpSwitch = [[UISwitch alloc] init];
    [dhcpSwitch addTarget:self action:@selector(dhcpSwitchChanged) forControlEvents:UIControlEventValueChanged];
    self.dhcpSwitch = dhcpSwitch;
    self.dhcpSwitch.on = bridgeConfig.dhcp.boolValue;
    self.dhcpSwitch.exclusiveTouch = YES;
    
    // Set proxy enabled or disabled
    UISwitch *proxySwitch = [[UISwitch alloc] init];
    [proxySwitch addTarget:self action:@selector(proxySwitchChanged) forControlEvents:UIControlEventValueChanged];
    self.proxySwitch = proxySwitch;
    self.proxySwitch.on = bridgeConfig.proxyPort.intValue != 0 && ![bridgeConfig.proxyAddress isEqualToString:@""];
    self.proxySwitch.exclusiveTouch = YES;
    
    // Reload the table to reflect current state
    [self reloadTableData];
}

/**
 Method called from save button
 */
- (IBAction)saveButton:(id)sender {
    // Check name
    NSString *name = self.nameLabel.text;
    if (name == nil || [name stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 || name.length < 4 || name.length > 16) {
        // Invalid name alert
        UIAlertView *invalidNameAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Invalid bridge name title")
                                                                   message:NSLocalizedString(@"Please insert a bridge name between 4 and 16 characters.", @"Invalid bridge name message")
                                                                  delegate:nil
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:NSLocalizedString(@"Ok", @"Invalid bridge name ok button"), nil];
        self.invalidNameAlert = invalidNameAlert;
        [invalidNameAlert show];
        return;
    }
    
    // Check ipaddresses (ipaddress, netmask, gateway)
    NSMutableArray *ipAddressesToCheck = [NSMutableArray array];
    if (!self.dhcpSwitch.on) {
        [ipAddressesToCheck addObject:self.ipAddressLabel.text];
        [ipAddressesToCheck addObject:self.netmaskLabel.text];
        [ipAddressesToCheck addObject:self.gatewayLabel.text];
    }
    
    for (NSString *ipAddress in ipAddressesToCheck) {
        BOOL valid = YES;
        NSArray *components = [ipAddress componentsSeparatedByString:@"."];
        
        if (components.count < 4) {
            valid = NO;
        }
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        for (NSString *component in components) {
            if ([component stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
                valid = NO;
                break;
            }
            
            if ([numberFormatter numberFromString:component].intValue > 255) {
                valid = NO;
                break;
            }
        }
        
        if (!valid) {
            UIAlertView *invalidName = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Invalid ip address entered title")
                                                                  message:NSLocalizedString(@"An invalid ip address was entered.", @"Invalid ip address entered message")
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:NSLocalizedString(@"Ok", @"Invalid ip address entered ok button"), nil];
            self.invalidNameAlert = invalidName;
            [invalidName show];
            return;
        }
    }
    
    // Show saving overlay
    self.loadingView = [[PHLoadingViewController alloc] initWithNibName:@"PHLoadingViewController" bundle:[NSBundle mainBundle]];
    self.loadingView.loadingLabel.text = NSLocalizedString(@"Saving...", @"Change light name save text");
    self.loadingView.view.frame = self.view.bounds;
    [self.view addSubview:self.loadingView.view];
    
    // Disable buttons
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Create config to send
    PHBridgeConfiguration *configToSave = [[PHBridgeConfiguration alloc] init];
    
    // Name
    configToSave.name = self.nameLabel.text;

    // DHCP
    if (self.dhcpSwitch.on) {
        // DHCP enabled
        configToSave.dhcp = [NSNumber numberWithBool:YES];
    }
    else {
        // Static ip enabled
        configToSave.dhcp = [NSNumber numberWithBool:NO];
        configToSave.ipaddress = self.ipAddressLabel.text;
        configToSave.netmask = self.netmaskLabel.text;
        configToSave.gateway = self.gatewayLabel.text;
    }
    
    // Proxy
    if (self.proxySwitch.on) {
        // Proxy enabled
        configToSave.proxyAddress = self.proxyAddressLabel.text;
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        configToSave.proxyPort = [numberFormatter numberFromString:self.proxyPortLabel.text];
    }
    else {
        // Proxy disabled
        configToSave.proxyAddress = @"none";
        configToSave.proxyPort = [NSNumber numberWithInt:0];
    }
    
    // Do the actual saving of the config
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    [bridgeSendAPI updateConfigurationWithConfiguration:configToSave completionHandler:^(NSArray *errors) {
        // Remove loading view overlay
        [self.loadingView.view removeFromSuperview];
        self.loadingView = nil;
        
        // Disable buttons
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        if (errors != nil) {
            // Show error
            UIAlertView *configErrorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Config change error popup title")
                                                                       message:NSLocalizedString(@"The new configuration could not be saved, please try again.", @"Config change error popup message")
                                                                      delegate:nil
                                                             cancelButtonTitle:nil
                                                             otherButtonTitles:NSLocalizedString(@"Ok", @"Config change error popup ok button"), nil];
            self.saveErrorAlert = configErrorAlert;
            [configErrorAlert show];
        }
        else {
            // Done, no errors, request close of screen by delegate
            [self.delegate closeBridgeConfigurationViewController:self];
        }
    }];
}

#pragma mark - Table view data source

- (void)reloadTableData {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Software update, (channel change), bridge name, DHCP and Proxy
    int sectionCount = 5;
    
    NSString *softwareVersion = [[PHBridgeResourcesReader readBridgeResourcesCache]  bridgeConfiguration].swversion;
    if ([softwareVersion isEqualToString:@"01003542"]) {
        // Software version "01003542" does not support channel change
        sectionCount--;
    }
    
    return sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *softwareVersion = [[PHBridgeResourcesReader readBridgeResourcesCache]  bridgeConfiguration].swversion;
    int i = 0;
    
    if (section == i++) {
        // Check for updates
    }
    else if ((![softwareVersion isEqualToString:@"01003542"]) && (section == i++)) {
        // Channel change
    }
    else if (section == i++) {
        return NSLocalizedString(@"Name", @"Title for bridge name section of my bridge config screen");
    }
    else if (section == i++) {
        return NSLocalizedString(@"DHCP", @"Title for bridge ip address section of my bridge config screen");
    }
    else if (section == i) {
        return NSLocalizedString(@"HTTP-proxy", @"Title for bridge proxy section of my bridge config screen");
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *softwareVersion = [[PHBridgeResourcesReader readBridgeResourcesCache]  bridgeConfiguration].swversion;
    int i = 0;
    
    if (section == i++) {
        // Check for updates
        return 1;
    }
    else if ((![softwareVersion isEqualToString:@"01003542"]) && (section == i++)) {
        // Channel change
        return 1;
    }
    else if (section == i++) {
        return 1;
    }
    else if (section == i++) {
        return self.dhcpSwitch.on ? 1 : 4;
    }
    else if (section == i) {
        return self.proxySwitch.on ? 3 : 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSString *editName = nil;
    UITextField *editField = nil;
    UISwitch *editSwitch = nil;
    
    int i = 0;
    if (indexPath.section == i++) {
        // Check for updates
        editName = NSLocalizedString(@"Check for updates", @"Check for updates button mybridge config screen");
    }
    else if (indexPath.section == i++) {
        // Name
        editName = NSLocalizedString(@"Name", @"Name label mybridge config screen");
        editField = self.nameLabel;
    }
    else if (indexPath.section == i++) {
        // Dhcp / ipaddress
        if (indexPath.row == 0) {
            // Switch
            editName = NSLocalizedString(@"DHCP", @"DHCP label mybridge config screen");
            editSwitch = self.dhcpSwitch;
        }
        else if (indexPath.row == 1) {
            // Ip address
            editName = NSLocalizedString(@"IP-address", @"Ipaddress label mybridge config screen");
            editField = self.ipAddressLabel;
        }
        else if (indexPath.row == 2) {
            // Netmask
            editName = NSLocalizedString(@"Netmask", @"Netmask label mybridge config screen");
            editField = self.netmaskLabel;
        }
        else if (indexPath.row == 3) {
            // Gateway
            editName = NSLocalizedString(@"Gateway", @"Gateway label mybridge config screen");
            editField = self.gatewayLabel;
        }
    }
    else if (indexPath.section == i) {
        // Http proxy
        if (indexPath.row == 0) {
            // Switch
            editName = NSLocalizedString(@"HTTP-proxy", @"Proxy label mybridge config screen");
            editSwitch = self.proxySwitch;
        }
        else if (indexPath.row == 1) {
            // Server
            editName = NSLocalizedString(@"Server", @"Proxy server label mybridge config screen");
            editField = self.proxyAddressLabel;
        }
        else if (indexPath.row == 2) {
            // Port
            editName = NSLocalizedString(@"Port", @"Proxy port label mybridge config screen");
            editField = self.proxyPortLabel;
        }
    }
    
    if (editName != nil) {
        cell.textLabel.text = editName;
    }
    if (editSwitch != nil) {
        cell.accessoryView = editSwitch;
    }
    else if (editField != nil) {
        editField.font = [UIFont systemFontOfSize:16];
        editField.textColor = [UIColor blueColor];
        editField.bounds = CGRectMake(0, 0, 150, 20);
        editField.textAlignment = NSTextAlignmentRight;
        editField.backgroundColor = [UIColor clearColor];
        cell.accessoryView = editField;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)dhcpSwitchChanged {
    int count = 0;
    
    NSString *softwareVersion = [[PHBridgeResourcesReader readBridgeResourcesCache]  bridgeConfiguration].swversion;
    if (![softwareVersion isEqualToString:@"01003542"]) {
        count++;
    }
    
    if (!self.dhcpSwitch.on) {
        // New state is dhcp off -> show fields
        NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:(2+count)], [NSIndexPath indexPathForRow:2 inSection:(2+count)], [NSIndexPath indexPathForRow:3 inSection:(2+count)], nil];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        // New state is dhcp on -> remove fields
        NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:(2+count)], [NSIndexPath indexPathForRow:2 inSection:(2+count)], [NSIndexPath indexPathForRow:3 inSection:(2+count)], nil];
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)proxySwitchChanged {
    int count = 0;
    
    NSString *softwareVersion = [[PHBridgeResourcesReader readBridgeResourcesCache]  bridgeConfiguration].swversion;
    if (![softwareVersion isEqualToString:@"01003542"]) {
        count++;
    }
    
    if (self.proxySwitch.on) {
        // New state is on
        NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:(3+count)], [NSIndexPath indexPathForRow:2 inSection:(3+count)], nil];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
        // New state is off
        NSArray *indexPathArray = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:(3+count)], [NSIndexPath indexPathForRow:2 inSection:(3+count)], nil];
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int i = 0;
    
    if (indexPath.section == i++) {
        // Check for updates button
        if (self.updateManager == nil) {
            self.updateManager = [[PHSoftwareUpdateManager alloc] initWithDelegate:self];
        }
        [self.updateManager checkUpdateStatus];
    }
    else if (indexPath.section == i++) {
        // Bridge name
        [self.nameLabel becomeFirstResponder];
    }
    else if (indexPath.section == i++) {
        // Dhcp / ipaddress
        if (indexPath.row == 1) {
            // Ip address
            [self.ipAddressLabel becomeFirstResponder];
        }
        else if (indexPath.row == 2) {
            // Netmask
            [self.netmaskLabel becomeFirstResponder];
        }
        else if (indexPath.row == 3) {
            // Gateway
            [self.gatewayLabel becomeFirstResponder];
        }
    }
    else if (indexPath.section == i) {
        // Http proxy
        if (indexPath.row == 1) {
            // Server
            [self.proxyAddressLabel becomeFirstResponder];
        }
        else if (indexPath.row == 2) {
            // Port
            [self.proxyPortLabel becomeFirstResponder];
        }
    }
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Update manager delegate

- (BOOL)shouldShowMessageForNoSoftwareUpdate {
    return YES;
}

- (BOOL)shouldShowMessageForDownloadingSoftwareUpdate {
    return YES;
}

- (BOOL)shouldIgnorePostponeDate {
    return YES;
}

- (void)softwareUpdateStarted {
    // Show saving overlay
    self.loadingView = [[PHLoadingViewController alloc] initWithNibName:@"PHLoadingViewController" bundle:[NSBundle mainBundle]];
    self.loadingView.loadingLabel.text = NSLocalizedString(@"Updating...", @"Updating loading view text");
    self.loadingView.view.frame = self.navigationController.view.bounds;
    [self.navigationController.view addSubview:self.loadingView.view];
}

- (void)softwareUpdateFinishedSuccessfull:(BOOL)success {
    // Remove loading view overlay
    [self.loadingView.view removeFromSuperview];
    self.loadingView = nil;
}

@end
