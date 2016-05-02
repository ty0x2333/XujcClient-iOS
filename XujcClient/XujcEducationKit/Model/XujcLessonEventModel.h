/**
 * @file XujcLessonEventModel.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "BaseModel.h"
#import "XujcSection.h"

@interface XujcLessonEventModel : BaseModel

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *lessonClassId;
@property(nonatomic, copy) NSString *eventDescription;

@property(nonatomic, copy) NSString *dayOfWeekName;

/**
 *  @brief  上课周间隔
 */
@property(nonatomic, copy) NSString *weekInterval;

@property(nonatomic, strong) XujcSection *startSection;
@property(nonatomic, strong) XujcSection *endSection;

@property(nonatomic, assign) NSInteger startWeek;
@property(nonatomic, assign) NSInteger endWeek;

@property(nonatomic, copy) NSString *location;

- (NSInteger)chineseDayOfWeek;

- (void)setStartSectionWithSectionNumbser:(NSInteger)sectionNumbser;
- (void)setEndSectionWithSectionNumbser:(NSInteger)sectionNumbser;

- (NSDate *)startTime:(NSDate *)date;

- (NSDate *)endTime:(NSDate *)date;

@end
