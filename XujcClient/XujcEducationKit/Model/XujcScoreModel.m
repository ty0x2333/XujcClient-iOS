//
//  XujcScoreModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "XujcScoreModel.h"
#import "XujcServiceKeys.h"

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
    return [NSString stringWithFormat:@"<%@: %p> { lessonName: %@, score: %zd }", NSStringFromClass([self class]), self, _lessonName, _score];
}

@end
