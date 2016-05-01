/**
 * @file NSDate+Week.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "NSDate+Week.h"

@implementation NSDate (Week)

- (NSDate *)dayOfCurrentWeek:(NSInteger)offset
{
    return [[[NSDate date] beginningOfWeek] dateByAddingTimeInterval:kTimeIntervalOfDay * offset];
}

+ (NSInteger)dayNumberOfWeekFromString:(NSString *)str
{
    NSArray *dayOfWeekChineseNames = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    return [dayOfWeekChineseNames indexOfObject:str] + 1;
}

+ (NSInteger)currentChineseDayOfWeek
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger dayOfWeek = [calender component:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    return dayOfWeek > 1 ? dayOfWeek - 1 : kDayCountOfWeek;
}

@end
