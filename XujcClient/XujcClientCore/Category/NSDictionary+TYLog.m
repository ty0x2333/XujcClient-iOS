//
//  NSDictionary+TYLog.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSDictionary+TYLog.h"

@implementation NSDictionary (TYLog)

- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level
{
    NSMutableString *description = [NSMutableString string];
    
    NSMutableString *indentString = [NSMutableString string];
    for (NSUInteger l = 0; l < level; ++l) {
        [indentString appendString:@"\t"];
    }
    
    [description appendString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [description appendFormat:@"%@\t%@ = %@,\n",
         indentString,
         key,
         [obj respondsToSelector:@selector(descriptionWithLocale:indent:)] ? [obj descriptionWithLocale:locale indent:level + 1] : obj
         ];
    }];
    [description appendFormat:@"%@}", indentString];
    
    return description;
}

@end
