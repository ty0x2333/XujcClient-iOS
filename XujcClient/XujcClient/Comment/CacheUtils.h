//
//  CacheUtils.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XujcSemesterModel.h"
#import "XujcScore.h"
#import "XujcLessonEventModel.h"

@interface CacheUtils : NSObject

+ (instancetype)instance;

- (BOOL)cacheSemesters:(NSArray<XujcSemesterModel *> *)semesters;

- (BOOL)cacheScore:(NSArray<XujcScore *> *)scores inSemester:(NSString *)semesterId;

- (BOOL)cacheLessonEvent:(NSArray<XujcLessonEventModel *> *)lessonEvents inSemester:(NSString *)semesterId;

/**
 *  @brief semesters in cache database
 *
 *  @note  semesters DESC
 */
- (NSArray<XujcSemesterModel *> *)semestersFormCache;

- (NSArray<XujcScore *> *)scoresFormCacheWithSemester:(NSString *)semesterId;

@end
