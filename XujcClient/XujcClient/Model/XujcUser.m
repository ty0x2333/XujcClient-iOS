/**
 * @file XujcUser.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcUser.h"

static NSString* const kDataStudentId = @"StudentId";
static NSString* const kDataName = @"Name";
static NSString* const kDataGrade = @"Grade";
static NSString* const kDataProfessional = @"Professional";

@implementation XujcUser

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _studentId = [self checkForNull:json[kResponseStudentId]];
        _name = [self checkForNull:json[kResponseName]];
        _professional = [self checkForNull:json[kResponseProfessional]];
        _grade = [self checkForNull:json[kResponseGrade]];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _studentId = [self checkForNull:dictionary[kDataStudentId]];
        _name = [self checkForNull:dictionary[kDataName]];
        _professional = [self checkForNull:dictionary[kDataGrade]];
        _grade = [self checkForNull:dictionary[kDataProfessional]];
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

- (NSDictionary *)dictionaryRepresentation
{
    NSString *null = @"";
    return @{
             kDataStudentId: _studentId ?: null,
             kDataName: _name ?: null,
             kDataGrade: _grade ?: null,
             kDataProfessional: _professional ?: null,
             };
}

- (NSString *)description
{
    return [[self dictionaryRepresentation] description];
}

@end
