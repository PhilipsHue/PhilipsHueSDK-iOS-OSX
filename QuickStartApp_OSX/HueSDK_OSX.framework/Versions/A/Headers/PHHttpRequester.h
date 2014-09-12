/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>

@class PHError;

/**
 Block for the response of the PHHttpRequester. It takes an integer (statusCode of the connection),
 NSData containing the response of the request and a PHError, for when an error occured.
 */
typedef void (^PHHttpRequesterCompletionHandler)(NSInteger statusCode, NSData *responseData, PHError *error);

/**
 Class used for sending http requests to the bridge and portal. The http connections are done asynchronous
 and will call the completionhandler given when done.
 */
@interface PHHttpRequester : NSObject


/**
 The url to send the request to
 */
@property (nonatomic, strong) NSString *url;

/**
 The method to use for the request (GET, POST, PUT or DELETE)
 */
@property (nonatomic, strong) NSString *method;

/**
 The body to send with the request
 */
@property (nonatomic, strong) NSData *body;

/**
 The request object
 */
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

/**
 Starts the actual connection and tries to execute the request.
 @param completionHandler block called when done
 @see PHHttpRequesterCompletionHandler
 */
- (void)runWithCompletionHandler:(PHHttpRequesterCompletionHandler)completionHandler;

/**
 Creates a urlConnection object for the given request object.
 @param request the request object
 @return an NSURLConnection object
 */
- (NSURLConnection *)createURLConnectionForRequest:(NSURLRequest *)request;

/**
 Cancels the request / connection if it currently running
 */
- (void)cancelRequest;

@end