//
//  AFHTTPSessionManager+TYService.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (TYService)

+ (instancetype)ty_manager;

+ (NSString *)ty_serviceBaseURL;

+ (NSString *)ty_shareURL;

- (RACSignal *)requestBindingXujcAccountSignalWithXujcKey:(NSString *)xujcKey;

@end
