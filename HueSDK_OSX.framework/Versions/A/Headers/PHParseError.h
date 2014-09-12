/*******************************************************************************
 Copyright (c) 2013-2014 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHError.h"

@interface PHParseError : PHError

@property(nonatomic,strong) NSString *parseValue;
@property(nonatomic,strong) NSString *resourceID;

- (NSArray*)getResourceIDsOfSubErrors;
- (NSArray*)getSubErrors;

- (void)addError:(NSObject*)error;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code resourceID:(NSString*)resourceID parseValue:(NSString*)JSONValue userInfo:(NSDictionary *)dict;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code resourceID:(NSString*)resourceID userInfo:(NSDictionary *)dict;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code parseValue:(NSString*)parseValue userInfo:(NSDictionary *)dict;


+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code subErrors:(NSArray*)subErrors userInfo:(NSDictionary *)dict;

@end
