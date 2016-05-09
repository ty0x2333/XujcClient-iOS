//
//  NSArray+TYLog.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSArray+TYLog.h"

@implementation NSArray (TYLog)

- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level
{
    NSMutableString *description = [NSMutableString string];
    
    NSMutableString *indentString = [NSMutableString string];
    for (NSUInteger l = 0; l < level; ++l) {
        [indentString appendString:@"\t"];
    }
    
    [description appendString:@"(\n"];
    
    for (id obj in self) {
        [description appendFormat:@"%@\t%@,\n",
         indentString,
         [obj respondsToSelector:@selector(descriptionWithLocale:indent:)] ? [obj descriptionWithLocale:locale indent:level + 1] : obj
         ];
    }
    [description appendFormat:@"%@)", indentString];
    
    return description;
}

@end
