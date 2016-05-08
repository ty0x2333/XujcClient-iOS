/**
 * @file XujcLessonEventModel.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcLessonEventModel.h"
#import "XujcServiceKeys.h"
#import "NSDate+Week.h"

@implementation XujcLessonEventModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _lessonClassId = [self checkForNull:json[XujcServiceKeyLessonClassId]];
        _eventDescription = [self checkForNull:json[XujcServiceKeyLessonEventDescription]];
        _dayOfWeekName = [self checkForNull:json[XujcServiceKeyLessonEventDayOfWeekName]];
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

- (NSInteger)chineseDayOfWeek
{
    return [NSDate chineseDayOfWeekFromString:self.dayOfWeekName];
}

- (NSDate *)startTime:(NSDate *)date
{
    return [_startSection startTime:date];
}

- (NSDate *)endTime:(NSDate *)date
{
    return [_endSection endTime:date];
}

- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString:[NSString stringWithFormat:@"<%@: %p> { ", NSStringFromClass([self class]), self]];
    [description appendString:[NSString stringWithFormat:@"%@: %@, ", @"name", self.name]];
    [description appendString:[NSString stringWithFormat:@"%@: %zd-%zd, ", @"week", self.startWeek, self.endWeek]];
    [description appendString:[NSString stringWithFormat:@"%@: %@ }", @"eventDescription", self.eventDescription]];
    return description;
}

@end
