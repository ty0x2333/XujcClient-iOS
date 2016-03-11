//
//  LessonTimeCalculator.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LESSON_TIME_CALCULATOR [LessonTimeCalculator instance]

@interface LessonTimeCalculator : NSObject

+ (instancetype)instance;

+ (NSTimeInterval)lessonDuration;

+ (NSInteger)earliestLessonNumber;

+ (NSInteger)lastLessonNumber;

- (NSDate *)firstLessonStartTime;

- (NSDate *)firstLessonStartTimeOfDay:(NSDate *)dayDate;

- (NSTimeInterval)timeIntervalRelativeToFirstLessonStartTime:(NSInteger)lessonNumber;

@end
