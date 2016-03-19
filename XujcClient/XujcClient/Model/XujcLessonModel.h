/**
 * @file XujcLessonModel.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "BaseModel.h"
#import "XujcLessonEventModel.h"

@interface XujcLessonModel : BaseModel

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *lessonClassId;
@property(nonatomic, copy) NSString *lessonClass;
@property(nonatomic, copy) NSString *semesterId;
@property(nonatomic, copy) NSString *teacherDescription;
/**
 *  @brief  学分
 */
@property(nonatomic, assign) NSInteger credit;
/**
 *  @brief  修课方式
 */
@property(nonatomic, copy) NSString *studyWay;
/**
 *  @brief  起始周
 */
@property(nonatomic, copy) NSString *studyWeekRange;
/**
 *  @brief  上课地点和时间的描述
 */
@property(nonatomic, copy) NSString *lessonEventDescription;

@property(nonatomic, strong) NSArray *lessonEvents;

//@property(nonatomic, copy) NSString *lessonClass_bz;
//@property(nonatomic, copy) NSString *lessonClass_rs;

@end
