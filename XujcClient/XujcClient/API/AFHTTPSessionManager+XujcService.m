//
//  AFHTTPSessionManager+XujcService.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AFHTTPSessionManager+XujcService.h"

static NSString* const kXujcServiceHost = @"http://jw.xujc.com/api/";

@implementation AFHTTPSessionManager (XujcService)

+ (instancetype)xujc_manager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[kXujcServiceHost copy]]];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    manager.requestSerializer.stringEncoding = encoding;
    return manager;
}

@end
