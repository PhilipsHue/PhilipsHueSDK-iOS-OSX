/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <Foundation/Foundation.h>
#import "PHHttpRequester.h"

@interface PHRequest : NSObject

/**
 Cancel the request
 Note; the completion handler of the request will not be called anymore
 */
- (void)cancel;

@end