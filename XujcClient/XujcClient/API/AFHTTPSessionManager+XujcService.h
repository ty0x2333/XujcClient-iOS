//
//  AFHTTPSessionManager+XujcService.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (XujcService)

+ (instancetype)xujc_manager;

- (RACSignal *)requestSemestersSignal;

- (RACSignal *)requestUserInformationSignalWithXujcKey:(NSString *)xujcKey;

- (RACSignal *)requestScoresSignalWithSemesterId:(NSString *)semesterId;

@end
