/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Cocoa/Cocoa.h>
#include "PHBridgePushLinkViewController.h"
#include "PHBridgeSelectionViewController.h"
#import <HueSDK_OSX/HueSDK.h>

#define NSAppDelegate  ((AppDelegate *)[[NSApplication sharedApplication] delegate])

@class PHHueSDK;

@interface AppDelegate : NSObject <NSApplicationDelegate,PHBridgePushLinkViewControllerDelegate,PHBridgeSelectionViewControllerDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) PHHueSDK *phHueSDK;

#pragma mark - HueSDK

/**
 Starts the local heartbeat
 */
- (void)enableLocalHeartbeat;

/**
 Stops the local heartbeat
 */
- (void)disableLocalHeartbeat;

/**
 Starts a search for a bridge
 */
- (void)searchForBridgeLocal;


@end
