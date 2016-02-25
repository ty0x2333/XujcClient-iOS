//
//  NSString+Safe.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSString+Safe.h"

@implementation NSString (Safe)

+ (BOOL)isEmpty:(NSString *)value
{
    return ![value isKindOfClass:[NSString class]] || [value length] == 0;
}

+ (NSString *)safeString:(NSString *)value
{
    return [NSString isEmpty:value] ? @"" : value;
}


@end
