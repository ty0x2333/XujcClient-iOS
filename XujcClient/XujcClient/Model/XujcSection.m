/**
 * @file XujcSection.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcSection.h"
#import "NSDate+Week.h"

@implementation XujcSection

+ (instancetype)section:(NSInteger)sectionNumber
{
    XujcSection *result = [[XujcSection alloc] init];
    result.sectionNumber = sectionNumber;
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
    return [[self startTime] dateByAddingTimeInterval:45 * kTimeIntervalOfMinute];
}

- (NSDate *)endTime:(NSDate *)currentDay
{
    return [[self startTime:currentDay] dateByAddingTimeInterval:45 * kTimeIntervalOfMinute];
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
    }else if (_sectionNumber == 5){
        interval = kTimeIntervalOfHour * 4 + kTimeIntervalOfMinute * 30;
    }else if (_sectionNumber == 6){
        interval = kTimeIntervalOfHour * 5 + kTimeIntervalOfMinute * 25;
    }else if (_sectionNumber == 7){
        interval = kTimeIntervalOfHour * 6 + kTimeIntervalOfMinute * 30;
    }else if (_sectionNumber == 8){
        interval = kTimeIntervalOfHour * 7 + kTimeIntervalOfMinute * 25;
    }else if (_sectionNumber == 9){
        interval = kTimeIntervalOfHour * 8 + kTimeIntervalOfMinute * 30;
    }else if (_sectionNumber == 10){
        interval = kTimeIntervalOfHour * 9 + kTimeIntervalOfMinute * 25;
    }else if (_sectionNumber == 11){
        interval = kTimeIntervalOfHour * 11 + kTimeIntervalOfMinute * 30;
    }else if (_sectionNumber == 12){
        interval = kTimeIntervalOfHour * 12 + kTimeIntervalOfMinute * 25;
    }
    return interval;
}

@end
