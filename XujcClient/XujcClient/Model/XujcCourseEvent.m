/**
 * @file XujcCourseEvent.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcCourseEvent.h"
#import "NSDate+Week.h"

@implementation XujcCourseEvent

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _courseClassId = [self checkForNull:json[kResponseCourseClassId]];
        _eventDescription = [self checkForNull:json[kResponseCourseEventDescription]];
        _studyDay = [self checkForNull:json[kResponseCourseEventStudyDay]];
        _weekInterval = [self checkForNull:json[kResponseCourseEventWeekInterval]];
        _startSection = [XujcSection section:[[self checkForNull:json[kResponseCourseEventStartSection]] integerValue]];
        _endSection = [XujcSection section:[[self checkForNull:json[kResponseCourseEventEndSection]] integerValue]];
        _startWeek = [[self checkForNull:json[kResponseCourseEventStartWeek]] integerValue];
        _endWeek = [[self checkForNull:json[kResponseCourseEventEndWeek]] integerValue];
        _location = [self checkForNull:json[kResponseCourseEventLocation]];
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
