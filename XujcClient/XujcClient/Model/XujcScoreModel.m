//
//  XujcScoreModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "XujcScoreModel.h"

@implementation XujcScoreModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _lessonName = [self checkForNull:json[XujcServiceKeyLessonName]];
        _credit = [[self checkForNull:json[XujcServiceKeyCredit]] integerValue];
        _score = [[self checkForNull:json[XujcServiceKeyLessonSorce]] integerValue];
        _scoreLevel = [self checkForNull:json[XujcServiceKeyLessonSorceLevel]];
        _midSemesterStatus = [self checkForNull:json[XujcServiceKeyMidSemesterStatus]];
        _endSemesterStatus = [self checkForNull:json[XujcServiceKeyEndSemesterStatus]];
        _studyWay = [self checkForNull:json[XujcServiceKeyScoreStudyWay]];
    }
    return self;
}

- (NSString *)description
{
    NSMutableString *description = [[super description] mutableCopy];
    [description appendFormat:@"{\n"];
    [description appendFormat:@"\n\tlessonName: %@", _lessonName];
    [description appendFormat:@"\n\tcredit: %zd", _credit];
    [description appendFormat:@"\n\tscore: %zd", _score];
    [description appendFormat:@"\n\tscoreLevel: %@", _scoreLevel];
    [description appendFormat:@"\n\tmidSemesterStatus: %@", _midSemesterStatus];
    [description appendFormat:@"\n\tendSemesterStatus: %@", _endSemesterStatus];
    [description appendFormat:@"\n\tstudyWay: %@", _studyWay];
    [description appendFormat:@"\n}"];
    return description;
}

@end
