//
//  CacheUtils.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "CacheUtils.h"
#import "FMDatabaseQueue+Utils.h"

@implementation CacheUtils

+ (instancetype)instance
{
    static CacheUtils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CacheUtils alloc] init];
        [sharedInstance initDataBase];
    });
    return sharedInstance;
}

- (void)initDataBase
{
    [[FMDatabaseQueue instance] inDatabase:^(FMDatabase *db) {
        
        NSString *sql = @"CREATE TABLE IF NOT EXISTS term ("
                        @"id integer PRIMARY KEY NOT NULL,"
                        @"name text"
                        @");";
        
        [db executeUpdate:sql];
    }];
}

- (BOOL)cacheTerms:(NSArray<XujcTerm *> *)terms
{
    __block BOOL isSuccess = NO;
    
    [[FMDatabaseQueue instance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (XujcTerm *term in terms) {
            isSuccess = [db executeUpdate:@"INSERT OR REPLACE INTO term(id, name) VALUES (?, ?);", term.termId, term.displayName];
            if (!isSuccess) {
                *rollback = YES;
                return;
            }
        }
    }];
    return isSuccess;
}

@end
