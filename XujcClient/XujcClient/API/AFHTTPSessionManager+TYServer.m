//
//  AFHTTPSessionManager+TYServer.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AFHTTPSessionManager+TYServer.h"

static NSString* const kTYServerHost = @"http://192.168.1.101:8080/";
static NSString* const kTYServerAPIVersion = @"v1/";

@implementation AFHTTPSessionManager (TYServer)

+ (instancetype)ty_manager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self ty_serviceBaseURL]]];
    return manager;
}

+ (NSString *)ty_serviceBaseURL
{
    return [NSString stringWithFormat:@"%@%@", kTYServerHost, kTYServerAPIVersion];
}

@end
