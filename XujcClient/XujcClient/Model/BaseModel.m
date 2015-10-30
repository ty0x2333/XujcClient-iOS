/**
 * @file BaseModel.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        NSAssert(false, @"Over initWithJSONResopnse in subclasses");
    }
    return self;
}

- (id)checkForNull:(id)value
{
    return value == [NSNull null] ? nil : value;
}

@end
