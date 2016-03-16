//
//  CacheUtils.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XujcTerm.h"
#import "XujcScore.h"

@interface CacheUtils : NSObject

+ (instancetype)instance;

- (BOOL)cacheTerms:(NSArray<XujcTerm *> *)terms;

- (BOOL)cacheScore:(NSArray<XujcScore *> *)scores inTerm:(NSString *)termId;

/**
 *  @brief terms in cache database
 *
 *  @note  terms DESC
 */
- (NSArray<XujcTerm *> *)termsFormCache;

@end
