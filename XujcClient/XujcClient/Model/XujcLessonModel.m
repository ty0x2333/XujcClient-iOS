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
        _name = [self checkForNull:json[XujcServiceKeyCourseName]];
        _courseClassId = [self checkForNull:json[XujcServiceKeyCourseClassId]];
        _courseClass = [self checkForNull:json[XujcServiceKeyCourseClass]];
        _semesterId = [self checkForNull:json[XujcServiceKeySemesterId]];
        _teacherDescription = [self checkForNull:json[XujcServiceKeyTeacherDescription]];
        _credit = [[self checkForNull:json[XujcServiceKeyCredit]] integerValue];
        _studyWay = [self checkForNull:json[XujcServiceKeyStudyWay]];
        _studyWeekRange = [self checkForNull:json[XujcServiceKeyStudyWeekRange]];
        _courseEventDescription = [self checkForNull:json[XujcServiceKeyCourseCourseEventDescription]];
        NSArray *courseEventDataArray = json[XujcServiceKeyCourseEvents];
        NSMutableArray *courseEventArray = [NSMutableArray arrayWithCapacity:courseEventDataArray.count];
        for (id courseEventData in courseEventDataArray) {
            XujcLessonEventModel *event = [[XujcLessonEventModel alloc] initWithJSONResopnse:courseEventData];
            event.name = _name;
            [courseEventArray addObject:event];
        }
        _courseEvents = courseEventArray;
        // TODO: unknow kcb_bz, kcb_rs
    }
    return self;
}

@end
