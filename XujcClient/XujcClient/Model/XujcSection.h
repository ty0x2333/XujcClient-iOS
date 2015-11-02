/**
 * @file XujcSection.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 *  @brief  课程小节
 */
@interface XujcSection : NSObject

@property(nonatomic, assign)NSInteger sectionNumber;

+ (instancetype)section:(NSInteger)sectionNumber;

- (NSDate *)startTime;
- (NSDate *)startTime:(NSDate *)currentDay;

- (NSDate *)endTime;
- (NSDate *)endTime:(NSDate *)currentDay;

+ (NSDate *)firstSectionStartTime;
+ (NSDate *)firstSectionStartTime:(NSDate *)currentDay;

@end
