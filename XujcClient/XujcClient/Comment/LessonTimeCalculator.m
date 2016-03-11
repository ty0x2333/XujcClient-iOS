//
//  LessonTimeCalculator.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LessonTimeCalculator.h"
#import "NSDate+Week.h"

@interface LessonTimeCalculator()

@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation LessonTimeCalculator

+ (instancetype)instance
{
    static LessonTimeCalculator *shareLessonTimeCalculatorInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareLessonTimeCalculatorInstance = [[self alloc] init];
    });
    return shareLessonTimeCalculatorInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _calendar = [NSCalendar currentCalendar];
    }
    return self;
}

+ (NSTimeInterval)lessonDuration
{
    return 45 * kTimeIntervalOfMinute;
}

- (NSDate *)firstLessonStartTime
{
    NSDateComponents *components = [_calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    components.hour = 8;
    components.minute = 0;
    return [_calendar dateFromComponents:components];
}

- (NSDate *)firstLessonStartTimeOfDay:(NSDate *)dayDate
{
    NSDateComponents *components = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:dayDate];
    components.hour = 8;
    components.minute = 0;
    return [_calendar dateFromComponents:components];
}


@end
