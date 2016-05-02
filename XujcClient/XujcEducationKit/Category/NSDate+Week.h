/**
 * @file NSDate+Week.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <Foundation/Foundation.h>

static NSInteger const kDayCountOfWeek = 7;
static NSInteger const kTimeIntervalOfDay = 60 * 60 * 24;
static NSInteger const kTimeIntervalOfHour = 60 * 60;
static NSInteger const kTimeIntervalOfMinute = 60;

@interface NSDate (Week)

/**
 *  @brief  获取当前周的星期几
 *
 *  @param offset 周几
 */
- (NSDate *)dayOfCurrentWeek:(NSInteger)offset;

+ (NSInteger)chineseDayOfWeekFromString:(NSString *)str;

+ (NSInteger)currentChineseDayOfWeek;

@end
