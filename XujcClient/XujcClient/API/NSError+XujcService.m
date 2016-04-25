//
//  NSError+XujcService.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSError+XujcService.h"

NSString * const XujcServiceRequestDomain = @"XujcServiceRequestDomain";

@implementation NSError (XujcService)

+ (NSError *)xujc_authenticationError
{
    return [NSError errorWithDomain:XujcServiceRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Xujc Key authentication failed", nil)}];
}

@end
