/**
 * @file XujcSection.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcSection.h"
#import "LessonTimeCalculator.h"

@implementation XujcSection

+ (instancetype)section:(NSInteger)sectionNumber
{
    XujcSection *result = [[XujcSection alloc] init];
    result.sectionNumber = sectionNumber;
    return result;
}

+ (instancetype)sectionIndex:(NSInteger)sectionIndex
{
    XujcSection *result = [[XujcSection alloc] init];
    result.sectionNumber = [LessonTimeCalculator sectionNumberFromSectionIndex:sectionIndex];
    return result;
}

#pragma mark - Getter

- (NSDate *)startTime
{
    NSDate *date = [LESSON_TIME_CALCULATOR firstLessonStartTime];
    NSTimeInterval interval = [LESSON_TIME_CALCULATOR timeIntervalRelativeToFirstLessonStartTimeWithLessonNumber:_sectionNumber];
    return [date dateByAddingTimeInterval:interval];
}

- (NSDate *)startTime:(NSDate *)currentDay
{
    NSDate *date = [LESSON_TIME_CALCULATOR firstLessonStartTimeOfDay:currentDay];
    NSTimeInterval interval = [LESSON_TIME_CALCULATOR timeIntervalRelativeToFirstLessonStartTimeWithLessonNumber:_sectionNumber];
    return [date dateByAddingTimeInterval:interval];
}

- (NSDate *)endTime
{
    return [[self startTime] dateByAddingTimeInterval:[LessonTimeCalculator lessonDuration]];
}

- (NSDate *)endTime:(NSDate *)currentDay
{
    return [[self startTime:currentDay] dateByAddingTimeInterval:[LessonTimeCalculator lessonDuration]];
}

#pragma mark - Getter

- (NSInteger)sectionIndex
{
    return [LessonTimeCalculator sectionIndexFromSectionNumber:self.sectionNumber];
}

@end
