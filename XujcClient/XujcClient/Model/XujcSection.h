/**
 * @file XujcSection.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "NSDate+Week.h"
/**
 *  @brief  课程小节
 */
@interface XujcSection : NSObject

@property(nonatomic, assign)NSInteger sectionNumber;
@property(nonatomic, readonly)NSInteger sectionIndex;
/**
 *  @brief  通过课程节的数字创建
 *  
 *  - 午课为 51, 52
 *  - 下午从 5 开始
 *
 *  @param sectionIndex 课程节的数字
 */
+ (instancetype)section:(NSInteger)sectionNumber;
/**
 *  @brief  通过课程节的序号创建
 *
 *  @param sectionIndex 课程节的序号
 */
+ (instancetype)sectionIndex:(NSInteger)sectionIndex;

- (NSDate *)startTime;
- (NSDate *)startTime:(NSDate *)currentDay;

- (NSDate *)endTime;
- (NSDate *)endTime:(NSDate *)currentDay;

@end
