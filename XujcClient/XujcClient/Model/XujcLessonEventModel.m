/**
 * @file XujcLessonEventModel.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcLessonEventModel.h"
#import "NSDate+Week.h"

@implementation XujcLessonEventModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _courseClassId = [self checkForNull:json[XujcServiceKeyCourseClassId]];
        _eventDescription = [self checkForNull:json[XujcServiceKeyCourseEventDescription]];
        _studyDay = [self checkForNull:json[XujcServiceKeyCourseEventStudyDay]];
        _weekInterval = [self checkForNull:json[XujcServiceKeyCourseEventWeekInterval]];
        _startSection = [XujcSection section:[[self checkForNull:json[XujcServiceKeyCourseEventStartSection]] integerValue]];
        _endSection = [XujcSection section:[[self checkForNull:json[XujcServiceKeyCourseEventEndSection]] integerValue]];
        _startWeek = [[self checkForNull:json[XujcServiceKeyCourseEventStartWeek]] integerValue];
        _endWeek = [[self checkForNull:json[XujcServiceKeyCourseEventEndWeek]] integerValue];
        _location = [self checkForNull:json[XujcServiceKeyCourseEventLocation]];
    }
    return self;
}

- (NSDate *)startTime:(NSDate *)date
{
    return [_startSection startTime:date];
}

- (NSDate *)endTime:(NSDate *)date
{
    return [_endSection endTime:date];
}


@end
