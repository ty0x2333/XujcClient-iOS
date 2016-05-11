//
//  NSError+Valid.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSError+Valid.h"

NSString * const TYValidErrorDomain = @"TYValidErrorDomain";

@implementation NSError (Valid)

+ (NSError *)ty_validPhoneError
{
    NSError *error = [NSError errorWithDomain:TYValidErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Phone Valid Error", nil)}];
    return error;
}

@end
