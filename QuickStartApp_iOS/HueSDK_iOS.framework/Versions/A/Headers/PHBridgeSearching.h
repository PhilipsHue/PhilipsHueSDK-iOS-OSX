/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@class PHHttpRequester;
@class AsyncUdpSocket;

/**
 This is a block used for getting the response of the bridge search class.
 It takes a dictionary as parameter, which contains the bridge id as keys and
 ip addresses as values.
 */
typedef void (^PHBridgeSearchCompletionHandler)(NSDictionary *bridgesFound);

/**
 This class is used for searching for SmartBridge using UPnP and portal based discovery.
 */
@interface PHBridgeSearching : NSObject

/**
 Socket used for doing the UPnP search
 */
@property (nonatomic, strong) AsyncUdpSocket *ssdpSocket;

/**
 Http requester used for portal search
 */
@property (nonatomic, strong) PHHttpRequester *httpRequester;

/**
 Initializes a PHBridgeSearch object which can search for bridges
 @param searchUpnp Indicates whether UPnP should be used for searching
 @param searchPortal Indicates whether portal based discovery should be used for searching
 @returns PHBridgeSearch instance
 */
- (id)initWithUpnpSearch:(BOOL)searchUpnp andPortalSearch:(BOOL)searchPortal __attribute((deprecated("Use 'initWithUpnpSearch:andPortalSearch:andIpAdressSearch:' method as replacement")));

/**
 Initializes a PHBridgeSearch object which can search for bridges
 @param searchUpnp Indicates whether UPnP should be used for searching
 @param searchPortal Indicates whether portal based discovery should be used for searching
 @param searchIpAdress Indicates whether IP adress searcg should be used for searching
 @returns PHBridgeSearch instance
 */
- (id)initWithUpnpSearch:(BOOL)searchUpnp andPortalSearch:(BOOL)searchPortal andIpAdressSearch:(BOOL)searchIpAdress;


/**
 Does a search for bridges, sends the result to the given completion handler.
 Searches configured with the initializer of this class will be executed in the following order: Upnp, Portal, Ip adress
 @param completionHandler the completion handler to call when done searching
 @see PHBridgeSearchCompletionHandler
 */
- (void)startSearchWithCompletionHandler:(PHBridgeSearchCompletionHandler)completionHandler;

/**
 Cancel the search for bridges.
 If a request is still in progress, it will be finished first before the cancellation
 */
- (void)cancelSearch;

@end