/**
 * @file XujcCourseEvent.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "BaseModel.h"
#import "XujcSection.h"

@interface XujcCourseEvent : BaseModel

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *courseClassId;
@property(nonatomic, copy) NSString *eventDescription;
/**
 *  @brief  周几
 */
@property(nonatomic, copy) NSString *studyDay;
/**
 *  @brief  上课周间隔
 */
@property(nonatomic, copy) NSString *weekInterval;

@property(nonatomic, strong) XujcSection *startSection;
@property(nonatomic, strong) XujcSection *endSection;

@property(nonatomic, assign) NSInteger startWeek;
@property(nonatomic, assign) NSInteger endWeek;

@property(nonatomic, copy) NSString *location;

- (NSDate *)startTime:(NSDate *)date;

- (NSDate *)endTime:(NSDate *)date;

@end
