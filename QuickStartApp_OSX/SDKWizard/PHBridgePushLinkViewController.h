/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Cocoa/Cocoa.h>

@class PHError;
@class PHHueSDK;

/**
 Delegate protocol for this bridge pushlink viewcontroller
 */
@protocol PHBridgePushLinkViewControllerDelegate <NSObject>

@required

/**
 Method which is invoked when the pushlinking was successful
 */
- (void)pushlinkSuccess;

/**
 Method which is invoked when the pushlinking failed
 @param error The error which caused the pushlinking to fail
 */
- (void)pushlinkFailed:(PHError *)error;

@end

/**
 This is the bridge pushlink sdk wizard. You can plug this viewcontroller into your application
 to allow pushlinking (authentication) of a local bridge in your app. You should change this class
 to include memory management if you are not using ARC.
 */

@interface PHBridgePushLinkViewController : NSViewController

@property (nonatomic, unsafe_unretained) id<PHBridgePushLinkViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet NSProgressIndicator *progressView;

/**
 Creates a new instance of this bridge pushlink view controller.
 @param hueSdk the hue sdk instance to use
 @param delegate the delegate to inform when pushlinking is done
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHBridgePushLinkViewControllerDelegate>)delegate;

/**
 Start the pushlinking process
 */
- (void)startPushLinking;

@end
