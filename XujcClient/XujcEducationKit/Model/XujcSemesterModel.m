/**
 * @file XujcSemesterModel.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/1
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcSemesterModel.h"

static NSString* const kDataSemesterId = @"SemesterId";
static NSString* const kDataSemesterDisplayName = @"SemesterDisplayName";


@implementation XujcSemesterModel

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]){
        _semesterId = [decoder decodeObjectForKey:kDataSemesterId];
        _displayName = [decoder decodeObjectForKey:kDataSemesterDisplayName];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_semesterId forKey:kDataSemesterId];
    [encoder encodeObject:_displayName forKey:kDataSemesterDisplayName];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> { %@: %@, %@: %@ }", NSStringFromClass([self class]), self, @"semesterId", self.semesterId, @"displayName", self.displayName];
}

@end
