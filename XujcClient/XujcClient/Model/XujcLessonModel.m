/**
 * @file XujcLessonModel.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcLessonModel.h"

@implementation XujcLessonModel

- (instancetype)initWithJSONResopnse:(NSDictionary *)json
{
    if (self = [super init]) {
        _name = [self checkForNull:json[XujcServiceKeyLessonName]];
        _lessonClassId = [self checkForNull:json[XujcServiceKeyLessonClassId]];
        _lessonClass = [self checkForNull:json[XujcServiceKeyLessonClass]];
        _semesterId = [self checkForNull:json[XujcServiceKeySemesterId]];
        _teacherDescription = [self checkForNull:json[XujcServiceKeyTeacherDescription]];
        _credit = [[self checkForNull:json[XujcServiceKeyCredit]] integerValue];
        _studyWay = [self checkForNull:json[XujcServiceKeyStudyWay]];
        _studyWeekRange = [self checkForNull:json[XujcServiceKeyStudyWeekRange]];
        _lessonEventDescription = [self checkForNull:json[XujcServiceKeyLessonLessonEventDescription]];
        NSArray *lessonEventDataArray = json[XujcServiceKeyLessonEvents];
        NSMutableArray *lessonEventArray = [NSMutableArray arrayWithCapacity:lessonEventDataArray.count];
        for (id lessonEventData in lessonEventDataArray) {
            XujcLessonEventModel *event = [[XujcLessonEventModel alloc] initWithJSONResopnse:lessonEventData];
            event.name = _name;
            [lessonEventArray addObject:event];
        }
        _lessonEvents = lessonEventArray;
        // TODO: unknow kcb_bz, kcb_rs
    }
    return self;
}

@end
