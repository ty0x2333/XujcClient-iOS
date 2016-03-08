//
//  AFHTTPSessionManager+XujcServer.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AFHTTPSessionManager+XujcServer.h"

static NSString* const kXujcServerHost = @"http://jw.xujc.com/api/";

@implementation AFHTTPSessionManager (XujcServer)

+ (instancetype)xujc_manager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[kXujcServerHost copy]]];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    manager.requestSerializer.stringEncoding = encoding;
    return manager;
}

@end
