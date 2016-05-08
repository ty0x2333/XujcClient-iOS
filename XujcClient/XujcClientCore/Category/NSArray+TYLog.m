//
//  NSArray+TYLog.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSArray+TYLog.h"

@implementation NSArray (TYLog)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *description = [NSMutableString string];
    
    [description appendString:@"(\n"];
    
    for (id obj in self) {
        [description appendFormat:@"\t%@,\n", obj];
    }
    [description appendString:@")"];
    
    return description;
}

@end
