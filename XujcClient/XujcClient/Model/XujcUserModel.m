/**
 * @file XujcUserModel.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcUserModel.h"

static NSString* const kDataStudentId = @"StudentId";
static NSString* const kDataName = @"Name";
static NSString* const kDataGrade = @"Grade";
static NSString* const kDataMajor = @"Major";

@implementation XujcUserModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _studentId = [self checkForNull:json[XujcServiceKeyStudentId]];
        _name = [self checkForNull:json[XujcServiceKeyName]];
        _major = [self checkForNull:json[XujcServiceKeyMajor]];
        _grade = [[self checkForNull:json[XujcServiceKeyGrade]] integerValue];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]){
        _studentId = [decoder decodeObjectForKey:kDataStudentId];
        _name = [decoder decodeObjectForKey:kDataName];
        _major = [decoder decodeObjectForKey:kDataGrade];
        _grade = [[decoder decodeObjectForKey:kDataMajor] integerValue];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_studentId forKey:kDataStudentId];
    [encoder encodeObject:_name forKey:kDataName];
    [encoder encodeObject:@(_grade) forKey:kDataMajor];
    [encoder encodeObject:_major forKey:kDataGrade];
}

- (NSString *)description
{
    return [[self p_dictionaryRepresentation] description];
}

#pragma mark - Helper

- (NSDictionary *)p_dictionaryRepresentation
{
    NSString *null = @"";
    return @{
             kDataStudentId: _studentId ?: null,
             kDataName: _name ?: null,
             kDataGrade: @(_grade),
             kDataMajor: _major ?: null,
             };
}

@end
