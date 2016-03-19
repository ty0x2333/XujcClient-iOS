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

#pragma mark - Xujc Lesson

static NSString* const XujcServiceKeyLessonClassId = @"kcb_id";
static NSString* const XujcServiceKeyLessonClass = @"kcb_mc";

static NSString* const XujcServiceKeyStudyWay = @"xsmd_xkfs";
static NSString* const XujcServiceKeyStudyWeekRange = @"kcb_qzz";
static NSString* const XujcServiceKeyCredit = @"kc_xf";


static NSString* const XujcServiceKeyLessonName = @"kc_mc";
static NSString* const XujcServiceKeyTeacherDescription = @"kcb_rkjs_desc";
static NSString* const XujcServiceKeyLessonLessonEventDescription = @"kcb_sksd_desc";
static NSString* const XujcServiceKeyLessonEvents = @"kcb_sksd";

//static NSString* const XujcServiceKeyLessonClass_rs = @"kcb_rs";
//static NSString* const XujcServiceKeyLessonClass_bz = @"kcb_bz";

#pragma mark - Xujc Score

static NSString* const XujcServiceKeyLessonSorce = @"zcj";
static NSString* const XujcServiceKeyLessonSorceLevel = @"zcj_dj";
static NSString* const XujcServiceKeyMidSemesterStatus = @"ksqk_qz";
static NSString* const XujcServiceKeyEndSemesterStatus = @"ksqk_qm";
static NSString* const XujcServiceKeyScoreStudyWay = @"xkfs";

#pragma mark - Xujc Lesson Event

static NSString* const XujcServiceKeyLessonEventDescription = @"sksd_mc";
static NSString* const XujcServiceKeyLessonEventStudyDay = @"sksd_xq";
static NSString* const XujcServiceKeyLessonEventWeekInterval = @"sksd_xq";
static NSString* const XujcServiceKeyLessonEventStartSection = @"sksd_jc_s";
static NSString* const XujcServiceKeyLessonEventEndSection = @"sksd_jc_e";
static NSString* const XujcServiceKeyLessonEventStartWeek = @"sksd_qzz_s";
static NSString* const XujcServiceKeyLessonEventEndWeek = @"sksd_qzz_e";
static NSString* const XujcServiceKeyLessonEventLocation = @"cr_mc";


#endif /* XujcServiceKeys_h */
