//
//  NSError+TYService.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSError+TYService.h"

NSString * const TYServiceRequestDomain = @"TYServiceRequestDomain";

@implementation NSError (TYService)

+ (NSError *)ty_authenticationError
{
    return [NSError errorWithDomain:TYServiceRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Authentication failed", nil)}];
}

@end
