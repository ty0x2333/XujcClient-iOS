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
    result.sectionNumber = [XujcSection sectionNumberFromSectionIndex:sectionIndex];
    return result;
}

#pragma mark - Getter

- (NSDate *)startTime
{
    NSDate *date = [LESSON_TIME_CALCULATOR firstLessonStartTime];
    NSTimeInterval interval = [LESSON_TIME_CALCULATOR timeIntervalRelativeToFirstLessonStartTime:_sectionNumber];
    return [date dateByAddingTimeInterval:interval];
}

- (NSDate *)startTime:(NSDate *)currentDay
{
    NSDate *date = [LESSON_TIME_CALCULATOR firstLessonStartTimeOfDay:currentDay];
    NSTimeInterval interval = [LESSON_TIME_CALCULATOR timeIntervalRelativeToFirstLessonStartTime:_sectionNumber];
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
    return [XujcSection sectionIndexFromSectionNumber:self.sectionNumber];
}

#pragma mark - Private Helper

+ (NSInteger)sectionIndexFromSectionNumber:(NSInteger)sectionNumber
{
    NSInteger sectionIndex = 0;
    if (sectionNumber < 5) {
        sectionIndex = sectionNumber;
    }else if (sectionNumber == 51) {
        sectionIndex = 5;
    }else if (sectionNumber == 52) {
        sectionIndex = 6;
    }else if (sectionIndex < 11) {
        sectionIndex = sectionNumber + 2;
    }
    return sectionIndex;
}

+ (NSInteger)sectionNumberFromSectionIndex:(NSInteger)sectionIndex
{
    NSInteger sectionNumber = 0;
    if (sectionIndex < 5) {
        sectionNumber = sectionIndex;
    }else if (sectionIndex == 5) {
        sectionNumber = 51;
    }else if (sectionIndex == 6) {
        sectionNumber = 52;
    }else if (sectionIndex < 13) {
        sectionNumber = sectionIndex - 2;
    }
    return sectionNumber;
}

@end
