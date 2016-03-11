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
    NSDate *date = [XujcSection firstSectionStartTime];
    NSTimeInterval interval = [self timeIntervalRelativeToFirstSectionStartTime];
    return [date dateByAddingTimeInterval:interval];
}

- (NSDate *)startTime:(NSDate *)currentDay
{
    NSDate *date = [XujcSection firstSectionStartTime:currentDay];
    NSTimeInterval interval = [self timeIntervalRelativeToFirstSectionStartTime];
    return [date dateByAddingTimeInterval:interval];
}

+ (NSDate *)firstSectionStartTime
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    components.hour = 8;
    components.minute = 0;
    return [calendar dateFromComponents:components];
}

+ (NSDate *)firstSectionStartTime:(NSDate *)currentDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:currentDay];
    components.hour = 8;
    components.minute = 0;
    return [calendar dateFromComponents:components];
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

/**
 *  @brief  获取相对于第一节课的时间偏移
 */
- (NSTimeInterval)timeIntervalRelativeToFirstSectionStartTime
{
    NSTimeInterval interval;
    if (_sectionNumber == 1){
        interval = 0;
    }else if (_sectionNumber == 2){
        interval = kTimeIntervalOfMinute * 55;
    }else if (_sectionNumber == 3){
        interval = kTimeIntervalOfHour * 2;
    }else if (_sectionNumber == 4){
        interval = kTimeIntervalOfHour * 2 + kTimeIntervalOfMinute * 55;
    }else if (_sectionNumber == 51){
        interval = kTimeIntervalOfHour * 4 + kTimeIntervalOfMinute * 30;
    }else if (_sectionNumber == 52){
        interval = kTimeIntervalOfHour * 5 + kTimeIntervalOfMinute * 25;
    }else if (_sectionNumber == 5){
        interval = kTimeIntervalOfHour * 6 + kTimeIntervalOfMinute * 30;
    }else if (_sectionNumber == 6){
        interval = kTimeIntervalOfHour * 7 + kTimeIntervalOfMinute * 25;
    }else if (_sectionNumber == 7){
        interval = kTimeIntervalOfHour * 8 + kTimeIntervalOfMinute * 30;
    }else if (_sectionNumber == 8){
        interval = kTimeIntervalOfHour * 9 + kTimeIntervalOfMinute * 25;
    }else if (_sectionNumber == 9){
        interval = kTimeIntervalOfHour * 11 + kTimeIntervalOfMinute * 30;
    }else if (_sectionNumber == 10){
        interval = kTimeIntervalOfHour * 12 + kTimeIntervalOfMinute * 25;
    }
    return interval;
}

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
