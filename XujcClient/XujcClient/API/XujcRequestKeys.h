/**
 * @file XujcRequestKeys.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#ifndef __XUJC_REQUEST_KEYS_H__
#define __XUJC_REQUEST_KEYS_H__

#pragma mark - Xujc User

static NSString* const kResponseStudentId = @"xj_id";
static NSString* const kResponseName = @"xj_xm";
static NSString* const kResponseGrade = @"xj_nj";
static NSString* const kResponseProfessional = @"zy_mc";

#pragma mark - Semester

static NSString* const kResponseSemesterId = @"tm_id";

#pragma mark - Xujc Course

static NSString* const kResponseCourseClassId = @"kcb_id";
static NSString* const kResponseCourseClass = @"kcb_mc";

static NSString* const kResponseStudyWay = @"xsmd_xkfs";
static NSString* const kResponseStudyWeekRange = @"kcb_qzz";
static NSString* const kResponseCredit = @"kc_xf";


static NSString* const kResponseCourseName = @"kc_mc";
static NSString* const kResponseTeacherDescription = @"kcb_rkjs_desc";
static NSString* const kResponseCourseCourseEventDescription = @"kcb_sksd_desc";
static NSString* const kResponseCourseEvents = @"kcb_sksd";

//static NSString* const kResponseCourseClass_rs = @"kcb_rs";
//static NSString* const kResponseCourseClass_bz = @"kcb_bz";

#pragma mark - Xujc Score

static NSString* const kResponseCourseSorce = @"zcj";
static NSString* const kResponseCourseSorceLevel = @"zcj_dj";
static NSString* const kResponseMidSemesterStatus = @"ksqk_qz";
static NSString* const kResponseEndSemesterStatus = @"ksqk_qm";
static NSString* const kResponseScoreStudyWay = @"xkfs";

#pragma mark - Xujc Course Event

static NSString* const kResponseCourseEventDescription = @"sksd_mc";
static NSString* const kResponseCourseEventStudyDay = @"sksd_xq";
static NSString* const kResponseCourseEventWeekInterval = @"sksd_xq";
static NSString* const kResponseCourseEventStartSection = @"sksd_jc_s";
static NSString* const kResponseCourseEventEndSection = @"sksd_jc_e";
static NSString* const kResponseCourseEventStartWeek = @"sksd_qzz_s";
static NSString* const kResponseCourseEventEndWeek = @"sksd_qzz_e";
static NSString* const kResponseCourseEventLocation = @"cr_mc";

#endif /* __XUJC_REQUEST_KEYS_H__ */
