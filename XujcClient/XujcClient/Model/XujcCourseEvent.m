/**
 * @file XujcCourseEvent.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcCourseEvent.h"

@implementation XujcCourseEvent

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _courseClassId = [self checkForNull:json[kResponseCourseClassId]];
        _eventDescription = [self checkForNull:json[kResponseCourseEventDescription]];
        _studyDay = [self checkForNull:json[kResponseCourseEventStudyDay]];
        _weekInterval = [self checkForNull:json[kResponseCourseEventWeekInterval]];
        _startTime = [[self checkForNull:json[kResponseCourseEventStartTime]] integerValue];
        _endTime = [[self checkForNull:json[kResponseCourseEventEndTime]] integerValue];
        _startWeek = [[self checkForNull:json[kResponseCourseEventStartWeek]] integerValue];
        _endWeek = [[self checkForNull:json[kResponseCourseEventEndWeek]] integerValue];
        _location = [self checkForNull:json[kResponseCourseEventLocation]];
    }
    return self;
}


@end
