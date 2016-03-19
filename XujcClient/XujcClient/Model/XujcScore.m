//
//  XujcScore.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "XujcScore.h"

@implementation XujcScore

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _courseName = [self checkForNull:json[XujcServiceKeyCourseName]];
        _credit = [[self checkForNull:json[XujcServiceKeyCredit]] integerValue];
        _score = [[self checkForNull:json[XujcServiceKeyCourseSorce]] integerValue];
        _scoreLevel = [self checkForNull:json[XujcServiceKeyCourseSorceLevel]];
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
    [description appendFormat:@"\n\tcourseName: %@", _courseName];
    [description appendFormat:@"\n\tcredit: %d", _credit];
    [description appendFormat:@"\n\tscore: %d", _score];
    [description appendFormat:@"\n\tscoreLevel: %@", _scoreLevel];
    [description appendFormat:@"\n\tmidSemesterStatus: %@", _midSemesterStatus];
    [description appendFormat:@"\n\tendSemesterStatus: %@", _endSemesterStatus];
    [description appendFormat:@"\n\tstudyWay: %@", _studyWay];
    [description appendFormat:@"\n}"];
    return description;
}

@end
