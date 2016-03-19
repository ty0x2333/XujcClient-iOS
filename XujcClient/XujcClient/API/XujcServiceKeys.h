//
//  XujcServiceKeys.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#ifndef XujcServiceKeys_h
#define XujcServiceKeys_h

static NSString* const XujcServiceKeyApiKey = @"apikey";

static NSString* const XujcServiceKeySemesterId = @"tm_id";

#pragma mark - Xujc User

static NSString* const XujcServiceKeyStudentId = @"xj_id";
static NSString* const XujcServiceKeyName = @"xj_xm";
static NSString* const XujcServiceKeyGrade = @"xj_nj";
static NSString* const XujcServiceKeyProfessional = @"zy_mc";

#pragma mark - Xujc Course

static NSString* const XujcServiceKeyCourseClassId = @"kcb_id";
static NSString* const XujcServiceKeyCourseClass = @"kcb_mc";

static NSString* const XujcServiceKeyStudyWay = @"xsmd_xkfs";
static NSString* const XujcServiceKeyStudyWeekRange = @"kcb_qzz";
static NSString* const XujcServiceKeyCredit = @"kc_xf";


static NSString* const XujcServiceKeyCourseName = @"kc_mc";
static NSString* const XujcServiceKeyTeacherDescription = @"kcb_rkjs_desc";
static NSString* const XujcServiceKeyCourseCourseEventDescription = @"kcb_sksd_desc";
static NSString* const XujcServiceKeyCourseEvents = @"kcb_sksd";

//static NSString* const XujcServiceKeyCourseClass_rs = @"kcb_rs";
//static NSString* const XujcServiceKeyCourseClass_bz = @"kcb_bz";

#pragma mark - Xujc Score

static NSString* const XujcServiceKeyCourseSorce = @"zcj";
static NSString* const XujcServiceKeyCourseSorceLevel = @"zcj_dj";
static NSString* const XujcServiceKeyMidSemesterStatus = @"ksqk_qz";
static NSString* const XujcServiceKeyEndSemesterStatus = @"ksqk_qm";
static NSString* const XujcServiceKeyScoreStudyWay = @"xkfs";

#pragma mark - Xujc Course Event

static NSString* const XujcServiceKeyCourseEventDescription = @"sksd_mc";
static NSString* const XujcServiceKeyCourseEventStudyDay = @"sksd_xq";
static NSString* const XujcServiceKeyCourseEventWeekInterval = @"sksd_xq";
static NSString* const XujcServiceKeyCourseEventStartSection = @"sksd_jc_s";
static NSString* const XujcServiceKeyCourseEventEndSection = @"sksd_jc_e";
static NSString* const XujcServiceKeyCourseEventStartWeek = @"sksd_qzz_s";
static NSString* const XujcServiceKeyCourseEventEndWeek = @"sksd_qzz_e";
static NSString* const XujcServiceKeyCourseEventLocation = @"cr_mc";


#endif /* XujcServiceKeys_h */
