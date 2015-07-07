/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

typedef enum {
    PORTALSTATE_COMMUNICATION_UNKNOWN, // It is unkown what the current communication state is
    PORTALSTATE_COMMUNICATION_CONNECTING, // The portal is connecting
    PORTALSTATE_COMMUNICATION_CONNECTED, // The portal is connected
    PORTALSTATE_COMMUNICATION_DISCONNECTED // The portal is disconnected
} PHPortalStateCommunication;

/**
 Object representing the portal state
 */
@interface PHPortalState : NSObject <NSCoding,NSCopying>
/**
 The bridge is signed on the portal
 */
@property (nonatomic, strong) NSNumber *signedOn;

/**
 The bridge is able to send messages to the portal
 */
@property (nonatomic, strong) NSNumber *outgoing;

/**
 The bridge is able to recieve messages from the portal
 */
@property (nonatomic, strong) NSNumber *incomming;

/**
 The bridge is communicating with SmartPortal
 */
@property (nonatomic, assign) PHPortalStateCommunication communication;

@end
