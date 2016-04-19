//
//  CacheUtils.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XujcSemesterModel.h"
#import "XujcScoreModel.h"
#import "XujcLessonEventModel.h"

@interface CacheUtils : NSObject

+ (instancetype)instance;

- (BOOL)cacheSemesters:(NSArray<XujcSemesterModel *> *)semesters;

- (BOOL)cacheScore:(NSArray<XujcScoreModel *> *)scores inSemester:(NSString *)semesterId;

- (BOOL)cacheLessonEvent:(NSArray<XujcLessonEventModel *> *)lessonEvents inSemester:(NSString *)semesterId;

/**
 *  @brief semesters in cache database
 *
 *  @note  semesters DESC
 */
- (NSArray<XujcSemesterModel *> *)semestersFormCache;

- (NSArray<XujcScoreModel *> *)scoresFormCacheWithSemester:(NSString *)semesterId;

- (NSArray<XujcLessonEventModel *> *)lessonEventFormCacheWithSemester:(NSString *)semesterId;

- (void)cleanCache;

@end
