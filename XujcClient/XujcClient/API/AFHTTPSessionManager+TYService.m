//
//  AFHTTPSessionManager+TYService.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AFHTTPSessionManager+TYService.h"

// Local
//static NSString* const kTYServiceHost = @"http://192.168.1.101:8080/";
// Online
static NSString* const kTYServiceHost = @"http://xujcservice.tianyiyan.com/";

static NSString* const kTYServiceAPIVersion = @"v1/";

@implementation AFHTTPSessionManager (TYService)

+ (instancetype)ty_manager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self ty_serviceBaseURL]]];
    return manager;
}

+ (NSString *)ty_serviceBaseURL
{
    return [NSString stringWithFormat:@"%@%@", kTYServiceHost, kTYServiceAPIVersion];
}

@end
