/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHConfigurationViewController.h"

#import "PHLoadingViewController.h"
#import "PHFindLightsStartViewController.h"

#import <HueSDK_iOS/HueSDK.h>

#define LIGHTNAME_MAX_LENGTH 32

@interface PHConfigurationViewController ()

/**
 The delegate object
 */
@property (nonatomic, unsafe_unretained) id<PHConfigurationViewControllerDelegate> delegate;

/**
 The loading view, shown when saving a new name
 */
@property (nonatomic, strong) PHLoadingViewController *loadingView;

/**
 The hue SDK instance
 */
@property (nonatomic, strong) PHHueSDK *phHueSDK;

/**
 A copy of the cache of lights, transformed to an array ordered by identifier
 */
@property (nonatomic, strong) NSArray *lights;

/**
 The alert shown for renaming a light
 */
@property (nonatomic, strong) UIAlertView *renameAlert;

/**
 The alert shown when an invalid name is entered
 */
@property (nonatomic, strong) UIAlertView *invalidAlert;

/**
 The currently edited light
 */
@property (nonatomic, strong) PHLight *editedLight;

/**
 The last entered invalid name of a light
 */
@property (nonatomic, strong) NSString *lastEnteredInvalidLightName;

@end

@implementation PHConfigurationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil hueSDK:(PHHueSDK *)hueSDK delegate:(id<PHConfigurationViewControllerDelegate>)delegate {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Make it a form on iPad
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        self.delegate = delegate;
        self.phHueSDK = hueSDK;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the title of the view
    self.title = NSLocalizedString(@"Configuration", @"Hue config screen title");
    
    // Load the lights from the cache
    [self updateLights];
    
    // Add notification listener for cache update of lights
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(updateLights) forNotification:LIGHTS_CACHE_UPDATED_NOTIFICATION];
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(connectionLost) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
    
    // Create a done button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)dealloc {
    // Deregister for notifications
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
}

/**
 Method invoked by the done button, this will request a close by the delegate.
 */
- (void)doneButton {
    // Close configuration screen
    [self.delegate closeConfigurationView:self];
}

/**
 Gets the lights from the cache of the SDK and than orders them in an array by identifier.
 Afterwards reloads the tableview.
 */
- (void)updateLights {
    NSDictionary *lightsDict = [[PHBridgeResourcesReader readBridgeResourcesCache] lights];
    self.lights = [lightsDict.allValues sortedArrayUsingComparator:^NSComparisonResult(PHLight *light1, PHLight *light2) {
        return [light1.identifier compare:light2.identifier options:NSNumericSearch];
    }];
    
    [self.tableView reloadData];
}

/**
 Closes popups on connection loss.
 */
- (void)connectionLost {
    // Connection lost, close rename popup when active
    if (self.renameAlert != nil) {
        [self.renameAlert dismissWithClickedButtonIndex:self.renameAlert.cancelButtonIndex animated:YES];
    }
    else if (self.invalidAlert) {
        [self.invalidAlert dismissWithClickedButtonIndex:self.invalidAlert.cancelButtonIndex animated:YES];
    }
}

/**
 Shows a popup to rename a light
 @param light the PHLight object to rename
 @param newName the name to show in the popup as "old" name. When This is nil, the popup will show the name value of the light object.
 */
- (void)renameLight:(PHLight *)light withNewName:(NSString *)newName {
    // Create alert with textfield
    UIAlertView *renameAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter light name", @"Light rename popup")
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button light rename popup")
                                                otherButtonTitles:NSLocalizedString(@"Ok", @"Ok button of light rename popup"), nil];
    
    renameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [renameAlert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [[renameAlert textFieldAtIndex:0] setDelegate:self];
    [[renameAlert textFieldAtIndex:0] setText:newName == nil ? light.name : newName];
    [[renameAlert textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    self.editedLight = light;
    self.renameAlert = renameAlert;
    [renameAlert show];
    
    // Make the light blink
    PHLightState *blinkState = [[PHLightState alloc] init];
    blinkState.alert = ALERT_LSELECT;
    
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    [bridgeSendAPI updateLightStateForId:light.identifier withLighState:blinkState completionHandler:^(NSArray *errors) {
        // Check for errors
        if (errors != nil) {
            // No contact with bridge
            self.editedLight = nil;
            [self.renameAlert dismissWithClickedButtonIndex:[self.renameAlert cancelButtonIndex] animated:YES];
            
            [self showRenameError];
        }
    }];
}

/**
 Shows common error when name change failed.
 */
- (void)showRenameError {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Light rename alert error title")
                                                         message:NSLocalizedString(@"Could not rename light, please try again.", @"Light rename alert error message")
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"Ok", @"Light rename alert error ok button"), nil];
    [errorAlert show];
}

/**
 Shows error when invalid name is given for light.
 */
- (void)showInvalidNameError {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Invalid light name alert error title")
                                                         message:NSLocalizedString(@"The name of a light should be between 1 and 32 characters.", @"Invalid light name alert error message")
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"Ok", @"Invalid light name alert error ok button"), nil];
    self.invalidAlert = errorAlert;
    [errorAlert show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.renameAlert) {
        // Light renamed
        if (self.editedLight != nil) {
            id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
            
            // Set light to normal non-blinking state again
            PHLightState *normalState = [[PHLightState alloc] init];
            normalState.alert = ALERT_NONE;
            
            [bridgeSendAPI updateLightStateForId:self.editedLight.identifier withLighState:normalState completionHandler:^(NSArray *errors) {
                // Ignore result, this may fail silently
            }];
            
            if (buttonIndex == 1) {
                // Ok button, name change wanted
                NSString *newName = [alertView textFieldAtIndex:0].text;
                
                // Check new name length
                if (newName.length == 0 || newName.length > 32) {
                    // Invalid name, show error and stop
                    self.lastEnteredInvalidLightName = newName;
                    [self showInvalidNameError];
                    return;
                }
                
                // Show loading view while saving
                self.loadingView = [[PHLoadingViewController alloc] initWithNibName:@"PHLoadingViewController" bundle:[NSBundle mainBundle]];
                self.loadingView.loadingLabel.text = NSLocalizedString(@"Saving...", @"Change light name save text");
                self.loadingView.view.frame = self.view.bounds;
                [self.view addSubview:self.loadingView.view];
                
                // Disable done button
                self.navigationItem.rightBarButtonItem.enabled = NO;
                
                // Keep old name for reference and set new name to light (for tableview update)
                NSString *oldName = self.editedLight.name;
                self.editedLight.name = newName;
                
                // Do the actual update of name
                [bridgeSendAPI updateLightWithLight:self.editedLight completionHandler:^(NSArray *errors) {
                    // Remove loading view
                    [self.loadingView.view removeFromSuperview];
                    self.loadingView = nil;
                    
                    // Check for errors
                    if (errors != nil) {
                        // Show error
                        self.editedLight.name = oldName;
                        [self showRenameError];
                    }
                    
                    // Reload tableview
                    [self.tableView reloadData];
                    self.editedLight = nil;
                    
                    // Enable done button again
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
                }];
            }
            else {
                // Cancel button
                self.editedLight = nil;
                [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
            }
        }
    }
    else if (alertView == self.invalidAlert) {
        // Invalid name alert, reopen change name alert
        if (self.editedLight != nil) {
            [self renameLight:self.editedLight withNewName:self.lastEnteredInvalidLightName];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // My bridge, Find bridge, Find lights and the edit lights section
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            // My bridge
            return 1;
            break;
        case 1:
            // Find new bridge
            return 1;
            break;
        case 2:
            // Find new lights
            return 1;
            break;
        case 3:
            // Edit lights
            return self.lights.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        // My bridge button
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = NSLocalizedString(@"My Bridge", @"My bridge button in configuration screen");
        
        NSString *softwareVersion = [NSString stringWithFormat:@"SW: %@", [[PHBridgeResourcesReader readBridgeResourcesCache]  bridgeConfiguration].swversion];
        cell.detailTextLabel.text = softwareVersion;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 1) {
        // Find new bridge button
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = NSLocalizedString(@"Find new bridge", @"Find new bridge button in configuration screen");
    }
    else if (indexPath.section == 2) {
        // Find new lights button
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = NSLocalizedString(@"Find new lights", @"Find new lights button in configuration screen");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        // Edit lights
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        PHLight *light = [self.lights objectAtIndex:indexPath.row];
        
        cell.textLabel.text = light.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"SW: %@, Model: %@", light.versionNumber, light.modelNumber];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return NSLocalizedString(@"Edit lights", @"Edit lights title in config screen");
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 3 && self.lights.count == 0) {
        // No lights
        return NSLocalizedString(@"No lights found, add lights using the 'Find new lights' button.", @"No lights known message in config screen");
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // My Bridge button
        PHBridgeConfigurationViewController *bridgeConfigViewController = [[PHBridgeConfigurationViewController alloc] initWithNibName:@"PHBridgeConfigurationViewController" bundle:[NSBundle mainBundle] delegate:self];
        [self.navigationController pushViewController:bridgeConfigViewController animated:YES];
    }
    else if (indexPath.section == 1) {
        // Find new bridge button
        [self.delegate startSearchForBridge:self];
    }
    else if (indexPath.section == 2) {
        // Find new lights button
        PHFindLightsStartViewController *findLightsStartViewController = [[PHFindLightsStartViewController alloc] initWithNibName:@"PHFindLightsStartViewController" bundle:[NSBundle mainBundle] delegate:self];
        [self.navigationController pushViewController:findLightsStartViewController animated:YES];
    }
    else {
        // Edit light buttons
        PHLight *light = [self.lights objectAtIndex:indexPath.row];
        
        [self renameLight:light withNewName:nil];
    }
}

#pragma mark - Bridge configuration view delegate

- (void)closeBridgeConfigurationViewController:(PHBridgeConfigurationViewController *)bridgeConfigurationViewController {
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - Find lights delegate

- (void)lightsSearchDone {
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if((textField.text.length >= LIGHTNAME_MAX_LENGTH && range.length == 0) ||
       (range.location + string.length > LIGHTNAME_MAX_LENGTH)) {
        return NO;
    }
    return YES;
}

@end
