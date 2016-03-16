/**
 * @file XujcSemesterModel.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/1
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcSemesterModel.h"

static NSString* const kDataTermId = @"TermId";
static NSString* const kDataTermDisplayName = @"TermDisplayName";


@implementation XujcSemesterModel

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]){
        _termId = [decoder decodeObjectForKey:kDataTermId];
        _displayName = [decoder decodeObjectForKey:kDataTermDisplayName];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_termId forKey:kDataTermId];
    [encoder encodeObject:_displayName forKey:kDataTermDisplayName];
}

@end
