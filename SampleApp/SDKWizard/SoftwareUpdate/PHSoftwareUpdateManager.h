/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@protocol PHSoftwareUpdateManagerDelegate <NSObject>

@required

/**
 The delegate decides if a message should be shown when there is no software update available.
 @return YES if a message should be shown, NO otherwise
 */
- (BOOL)shouldShowMessageForNoSoftwareUpdate;

/**
 The delegate decides if a message should be shown when a software update is being downloaded.
 @return YES if a message should be shown, NO otherwise
 */
- (BOOL)shouldShowMessageForDownloadingSoftwareUpdate;

/**
 The delegate decides if a message about a downloaded software update should be shown even though the postpone date of that
 software update has not passed yet.
 */
- (BOOL)shouldIgnorePostponeDate;

/**
 This method is called when the software update manager send a software update start command to the bridge.
 */
- (void)softwareUpdateStarted;

/**
 This method is called when the software update manager finished a software update of the bridge.
 @param success indicates whether the update was successful.
 */
- (void)softwareUpdateFinishedSuccessfull:(BOOL)success;

@end

@interface PHSoftwareUpdateManager : NSObject

/**
 Create an instance of this class with the given delegate
 @param delegate the delegate
 */
- (id)initWithDelegate:(id<PHSoftwareUpdateManagerDelegate>)delegate;

/**
 Checks for the update status and shows the appropriate messages when nessecary.
 */
- (void)checkUpdateStatus;

/**
 Cancels the current check of the software update state, including closing any open popups.
 Note that the actual update of the bridge cannot be cancelled when started.
 */
- (void)cancelCheck;

@end
