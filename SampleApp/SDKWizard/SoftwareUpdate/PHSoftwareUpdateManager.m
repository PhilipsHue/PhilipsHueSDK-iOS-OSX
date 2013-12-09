/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHSoftwareUpdateManager.h"
#import "PHAppDelegate.h"

#import <HueSDK_iOS/HueSDK.h>

#define NO_PORTALSERVICES 99

@interface PHSoftwareUpdateManager ()

/**
 The delegate
 */
@property (nonatomic, unsafe_unretained) id<PHSoftwareUpdateManagerDelegate> delegate;

/**
 The alert shown when the update button is clicked
 */
@property (nonatomic, strong) UIAlertView *updateAlert;

/**
 Overall timer to check for a timeout of the software update (another device may have picked up the end signal).
 */
@property (nonatomic, strong) NSTimer *timeoutTimer;

/**
 Boolean indicating whether this software update manager is cancelled.
 */
@property (nonatomic, assign) BOOL cancelled;

@end

@implementation PHSoftwareUpdateManager

- (id)initWithDelegate:(id<PHSoftwareUpdateManagerDelegate>)delegate {
    self = [super init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)checkUpdateStatus {
    PHBridgeConfiguration *bridgeConfig = [PHBridgeResourcesReader readBridgeResourcesCache].bridgeConfiguration;
    PHSoftwareUpdateStatus *swUpdateStatus = bridgeConfig.softwareUpdate;
    
    if (swUpdateStatus != nil) {
        if (swUpdateStatus.updateState == NO_UPDATE && [self.delegate shouldShowMessageForNoSoftwareUpdate]) {
            BOOL portalServiceEnabled = [[[PHBridgeResourcesReader readBridgeResourcesCache] bridgeConfiguration].portalServices boolValue];
            if (!portalServiceEnabled) {
                [self showTurnPortalServicesOnAndAgreeToTermsMessage];
            }
            else {
                // No update
                [self showNoUpdateMessage];
            }
        }
        else if (swUpdateStatus.updateState == UPDATE_DOWNLOADING && [self.delegate shouldShowMessageForDownloadingSoftwareUpdate]) {
            // Downloading update
            [self showUpdateDownloadingMessage];
        }
        else if (swUpdateStatus.updateState == UPDATE_READY_FOR_INSTALL) {
            // Update ready for installation
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            NSDate *postponeDate = [userDefaults objectForKey:@"swupdatePostponeDate"];
            NSData *encodedSwUpdateStatus = [userDefaults objectForKey:@"swupdatePostponeDetails"];
            PHSoftwareUpdateStatus *postponedSWUpdate = (PHSoftwareUpdateStatus *)[NSKeyedUnarchiver unarchiveObjectWithData: encodedSwUpdateStatus];
            
            if (postponedSWUpdate == nil || postponeDate == nil || [self.delegate shouldIgnorePostponeDate]) {
                // Unknown values, show update message
                [self showUpdateReadyMessage];
            }
            else {
                // Check if postpone date has passed and if this is the same update
                if (![postponedSWUpdate isEqual:swUpdateStatus]) {
                    // New software update
                    [self showUpdateReadyMessage];
                }
                else {
                    // Same update
                    NSDate *currentDate = [NSDate date];
                    if ([currentDate compare:postponeDate] == NSOrderedDescending) {
                        // Postpone date has passed, show update
                        [self showUpdateReadyMessage];
                    }
                }
            }
        }
        else if (swUpdateStatus.updateState == UPDATE_INSTALLED) {
            // Update installed
            [self showUpdateDoneMessage];
        }
    }
}

- (void)cancelCheck {
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    
    self.cancelled = YES;
    
    if (self.updateAlert != nil) {
        [self.updateAlert dismissWithClickedButtonIndex:[self.updateAlert cancelButtonIndex] animated:YES];
    }
}

#pragma mark - Alert messages

- (void)showTurnPortalServicesOnAndAgreeToTermsMessage {
    if (self.updateAlert == nil) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Portal services", @"Title of portal services update alert")
                                                                            message:NSLocalizedString(@"Do you want to turn portal services on and agree to the terms?", @"Message of portal service update alert")
                                                                           delegate:self
                                                                  cancelButtonTitle:nil
                                                                  otherButtonTitles:NSLocalizedString(@"Yes", @"Yes button of portal service update alert"),
                                                                                    NSLocalizedString(@"No", @"No button of portal service update alert"),
                                                                                    NSLocalizedString(@"Terms", @"Terms button of portal service update alert"), nil];
        updateAlert.tag = NO_PORTALSERVICES;
        self.updateAlert = updateAlert;
        [updateAlert show];
    }
}

- (void)showNoUpdateMessage {
    if (self.updateAlert == nil) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Software update", @"Title of no software update alert")
                                                              message:NSLocalizedString(@"Your system is up to date.", @"Message of no software update alert")
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Ok", @"Ok button of no software update alert"), nil];
        updateAlert.tag = NO_UPDATE;
        self.updateAlert = updateAlert;
        [updateAlert show];
    }
}

- (void)showUpdateDownloadingMessage {
    if (self.updateAlert == nil) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Software update", @"Title of downloading software update alert")
                                                              message:NSLocalizedString(@"A software update is being downloaded, you will be notified when it is ready.", @"Message of downloading software update alert")
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Ok", @"Ok button of no software update alert"), nil];
        updateAlert.tag = UPDATE_DOWNLOADING;
        self.updateAlert = updateAlert;
        [updateAlert show];
    }
}

- (void)showUpdateReadyMessage {
    if (self.updateAlert == nil) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Software update", @"Title of software update ready alert")
                                                              message:NSLocalizedString(@"A software update is available for your system, would you like to install it now?", @"Message of software update ready alert")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Not now", @"No button of software update ready alert")
                                                    otherButtonTitles:NSLocalizedString(@"Yes", @"Yes button of software update ready alert"), nil];
        updateAlert.tag = UPDATE_READY_FOR_INSTALL;
        self.updateAlert = updateAlert;
        [updateAlert show];
    }
}

- (void)showUpdateDoneMessage {
    if (self.updateAlert == nil) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Software update", @"Title of finished software update alert")
                                                              message:NSLocalizedString(@"A software update was successfully installed on your system.", @"Message of finished software update alert")
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Ok", @"Ok button of finished software update alert"), nil];
        updateAlert.tag = UPDATE_INSTALLED;
        self.updateAlert = updateAlert;
        [updateAlert show];
    }
}

- (void)showSoftwareUpdateFailedMessage {
    if (self.updateAlert == nil) {
        UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Software update", @"Title of failed software update alert")
                                                              message:NSLocalizedString(@"The software update failed, please try again later.", @"Message of failed software update alert")
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Ok", @"Ok button of failed software update alert"), nil];
        self.updateAlert = updateAlert;
        [updateAlert show];
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.updateAlert) {
        self.updateAlert = nil;
        
        if (alertView.tag == NO_PORTALSERVICES) {
            if (buttonIndex == 0) {
                // Yes button (enable portalservice)
                PHBridgeConfiguration *bridgeConfig = [[PHBridgeConfiguration alloc] init];
                bridgeConfig.portalServices = [NSNumber numberWithBool:YES];
                id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
                [bridgeSendAPI updateConfigurationWithConfiguration:bridgeConfig completionHandler:^(NSArray *errors) {
                    if (errors != nil) {
                        // Show error
                        UIAlertView *configErrorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Config change error popup title")
                                                                                   message:NSLocalizedString(@"The new configuration could not be saved, please try again.", @"Config change error popup message")
                                                                                  delegate:nil
                                                                         cancelButtonTitle:nil
                                                                         otherButtonTitles:NSLocalizedString(@"Ok", @"Config change error popup ok button"), nil];
                        [configErrorAlert show];
                    }
                    else {
                        // Done, no errors, check for bridge update
                        [self checkUpdateStatus];
                    }
                }];
            }
            else if (buttonIndex == 1) {
                // No button
            }
            else if (buttonIndex == 2) {
                // Terms and conditions button
                NSURL *url = [NSURL URLWithString:@"https://www.meethue.com/terms"];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        else if (alertView.tag == NO_UPDATE) {
            // Nothing to do here
        }
        else if (alertView.tag == UPDATE_DOWNLOADING) {
            // Nothing to do here
        }
        else if (alertView.tag == UPDATE_READY_FOR_INSTALL) {
            if (buttonIndex == alertView.cancelButtonIndex) {
                // Not now button, postpone this
                PHBridgeConfiguration *bridgeConfig = [PHBridgeResourcesReader readBridgeResourcesCache].bridgeConfiguration;
                PHSoftwareUpdateStatus *swUpdateStatus = bridgeConfig.softwareUpdate;
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:7 * 24 * 60 * 60] forKey:@"swupdatePostponeDate"]; // Postpone by 7 days
                
                NSData *encodedSwUpdateStatus = [NSKeyedArchiver archivedDataWithRootObject:swUpdateStatus];
                [userDefaults setObject:encodedSwUpdateStatus forKey:@"swupdatePostponeDetails"];
            }
            else {
                // Install button, start software update
                
                // First disable the heartbeat (as the bridge might not respond for a while)
                [UIAppDelegate disableLocalHeartbeat];
                
                [self.delegate softwareUpdateStarted];
                id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
                [bridgeSendAPI softwareUpdateStart:^(NSArray *errors) {
                    // Start timer for checking if this finished
                    [self.timeoutTimer invalidate];
                    self.timeoutTimer = nil;
                    
                    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(timeoutCheck) userInfo:nil repeats:NO];
                    [self intervalCheck];
                }];
            }
        }
        else if (alertView.tag == UPDATE_INSTALLED) {
            // Update is done, remove notify
            id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
            [bridgeSendAPI softwareUpdateRemoveNotify:^(NSArray *errors) {
                [UIAppDelegate enableLocalHeartbeat];
            }];
        }
    }
}

#pragma mark - Software update finished checking

- (void)intervalCheck {
    // Check if connection is restored and the notify flag is set
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    [bridgeSendAPI getSoftwareUpdateStatus:^(PHSoftwareUpdateStatus *softwareUpdateStatus, NSArray *errors) {
        BOOL done = NO;
        
        if (softwareUpdateStatus != nil) {
            // We have a software update state
            if (softwareUpdateStatus.updateState == UPDATE_INSTALLED) {
                // Update is finished
                done = YES;
                
                [self showUpdateDoneMessage];
                
                // Report back to the delegate
                [self.delegate softwareUpdateFinishedSuccessfull:YES];
            }
        }
        
        if (!done && !self.cancelled) {
            [self performSelector:@selector(intervalCheck) withObject:nil afterDelay:1];
        }
    }];
}

- (void)timeoutCheck {
    // Check is finished, just continue normal operation
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    
    self.cancelled = YES;
    
    // Enable heartbeat again
    [UIAppDelegate enableLocalHeartbeat];
    
    // Report back to the delegate
    [self.delegate softwareUpdateFinishedSuccessfull:NO]; // No because we did not get an installation finished flag
}

@end
