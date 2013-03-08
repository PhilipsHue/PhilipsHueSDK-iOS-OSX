//
//  PHOverallFactory.h
//  HueSDK v1.0 beta
//
//  Copyright (c) 2012-2013 Philips. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PHBridgeSendAPI.h"

/**
 This is the overall factory to use for app developers.
 */
@interface PHOverallFactory : NSObject

/**
 This will return an initialized and fully set up bridge send API instance.
 This is used to send commands to the bridge using the local network.
 @return the PHBridgeSendAPI instance
 */
- (id<PHBridgeSendAPI>)bridgeSendAPI;

@end
