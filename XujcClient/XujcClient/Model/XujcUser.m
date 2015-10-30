/**
 * @file XujcUser.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcUser.h"
static NSString* const kResponseStudentId = @"xj_id";
static NSString* const kResponseName = @"xj_xm";
static NSString* const kResponseGrade = @"xj_nj";
static NSString* const kResponseProfessional = @"zy_mc";

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
