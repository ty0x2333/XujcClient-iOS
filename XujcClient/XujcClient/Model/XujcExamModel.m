//
//  XujcExamModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "XujcExamModel.h"

@implementation XujcExamModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _lessonName = [self checkForNull:json[XujcServiceKeyLessonName]];
        _location = [self checkForNull:json[XujcServiceKeyLessonEventLocation]];
        _startDate = [self checkForNull:json[XujcServiceKeyExamStartDate]];
        _timePeriod = [self checkForNull:json[XujcServiceKeyExamTimePeriod]];
        _time = [self checkForNull:json[XujcServiceKeyExamTime]];
        _way = [self checkForNull:json[XujcServiceKeyExamWay]];
        _week = [self checkForNull:json[XujcServiceKeyExamWeek]];
        _name = [self checkForNull:json[XujcServiceKeyExamName]];
        _status = [self checkForNull:json[XujcServiceKeyExamStatus]];
    }
    return self;
}


@end
