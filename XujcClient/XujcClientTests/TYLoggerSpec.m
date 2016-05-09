//
//  TYLoggerSpec.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Kiwi.h>
#import "NSDictionary+TYLog.h"
#import "NSArray+TYLog.h"

#define name(type) NSStringFromClass([type class])

SPEC_BEGIN(TYLoggerSpec)

describe(@"Validator", ^{
    NSMutableDictionary *baseDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                            name(NSString) : @"text",
                                                                                            name(NSNumber) : @(0),
                                                                                            name(NSNull) : [NSNull null],
                                                                                            @"UTF8" : @"文本"
                                                                                            }];
    
    NSMutableArray *baseArray = [NSMutableArray array];
    [baseDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [baseArray addObject:obj];
    }];
    
    context(@"test logger", ^{
        NSMutableDictionary *dictionary = [baseDictionary mutableCopy];
        
        NSMutableDictionary *subDictionary = [baseDictionary mutableCopy];
        [subDictionary setObject:[baseDictionary copy] forKey:name(NSDictionary)];
        
        NSMutableArray *array = [baseArray mutableCopy];
        [array addObject:[subDictionary copy]];
        [array addObject:[baseArray copy]];
        
        [subDictionary setObject:[array copy] forKey:name(NSArray)];
        
        [dictionary setObject:[subDictionary copy] forKey:name(NSDictionary)];
        NSLog(@"%@", [dictionary copy]);
    });
});

SPEC_END
