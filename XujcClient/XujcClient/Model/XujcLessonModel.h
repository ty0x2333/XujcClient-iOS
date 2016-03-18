/**
 * @file XujcLessonModel.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "BaseModel.h"
#import "XujcCourseEvent.h"

@interface XujcLessonModel : BaseModel

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *courseClassId;
@property(nonatomic, copy) NSString *courseClass;
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
@property(nonatomic, copy) NSString *courseEventDescription;

@property(nonatomic, strong) NSArray *courseEvents;

//@property(nonatomic, copy) NSString *courseClass_bz;
//@property(nonatomic, copy) NSString *courseClass_rs;

@end
