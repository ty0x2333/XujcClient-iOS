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
static NSString* const kDataProfessional = @"Professional";

@implementation XujcUserModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _studentId = [self checkForNull:json[XujcServiceKeyStudentId]];
        _name = [self checkForNull:json[XujcServiceKeyName]];
        _professional = [self checkForNull:json[XujcServiceKeyProfessional]];
        _grade = [self checkForNull:json[XujcServiceKeyGrade]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]){
        _studentId = [decoder decodeObjectForKey:kDataStudentId];
        _name = [decoder decodeObjectForKey:kDataName];
        _professional = [decoder decodeObjectForKey:kDataGrade];
        _grade = [decoder decodeObjectForKey:kDataProfessional];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_studentId forKey:kDataStudentId];
    [encoder encodeObject:_name forKey:kDataName];
    [encoder encodeObject:_grade forKey:kDataProfessional];
    [encoder encodeObject:_professional forKey:kDataGrade];
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
             kDataGrade: _grade ?: null,
             kDataProfessional: _professional ?: null,
             };
}

@end
