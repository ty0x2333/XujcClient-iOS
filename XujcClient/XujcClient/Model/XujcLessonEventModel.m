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
        _lessonClassId = [self checkForNull:json[XujcServiceKeyLessonClassId]];
        _eventDescription = [self checkForNull:json[XujcServiceKeyLessonEventDescription]];
        _studyDay = [self checkForNull:json[XujcServiceKeyLessonEventStudyDay]];
        _weekInterval = [self checkForNull:json[XujcServiceKeyLessonEventWeekInterval]];
        _startSection = [XujcSection section:[[self checkForNull:json[XujcServiceKeyLessonEventStartSection]] integerValue]];
        _endSection = [XujcSection section:[[self checkForNull:json[XujcServiceKeyLessonEventEndSection]] integerValue]];
        _startWeek = [[self checkForNull:json[XujcServiceKeyLessonEventStartWeek]] integerValue];
        _endWeek = [[self checkForNull:json[XujcServiceKeyLessonEventEndWeek]] integerValue];
        _location = [self checkForNull:json[XujcServiceKeyLessonEventLocation]];
    }
    return self;
}

- (void)setStartSectionWithSectionNumbser:(NSInteger)sectionNumbser
{
    self.startSection = [XujcSection section:sectionNumbser];
}

- (void)setEndSectionWithSectionNumbser:(NSInteger)sectionNumbser
{
    self.endSection = [XujcSection section:sectionNumbser];
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
