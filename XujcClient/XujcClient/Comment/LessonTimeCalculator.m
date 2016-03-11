//
//  LessonTimeCalculator.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LessonTimeCalculator.h"
#import "NSDate+Week.h"

#define LESSON_TIME_CALCULATOR [LessonTimeCalculator instance]

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

+ (NSTimeInterval)lessonDuration
{
    return 45 * kTimeIntervalOfMinute;
}

@end
