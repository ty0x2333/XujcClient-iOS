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
        
        NSString *termTableSQL = @"CREATE TABLE IF NOT EXISTS term ("
                                 @"id integer PRIMARY KEY NOT NULL,"
                                 @"name text"
                                 @");";
        
        NSString *scoreTableSQL = @"CREATE TABLE IF NOT EXISTS score ("
                                  @"term_id text NOT NULL,"
                                  @"name text NOT NULL,"
                                  @"credit integer,"
                                  @"score integer,"
                                  @"study_way text,"
                                  @"score_level text,"
                                  @"mid_term_status text,"
                                  @"end_term_status text,"
                                  @"PRIMARY KEY(term_id, name)"
                                  @");";
        
        [db executeUpdate:termTableSQL];
        [db executeUpdate:scoreTableSQL];
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

- (BOOL)cacheScore:(NSArray<XujcScore *> *)scores inTerm:(NSString *)termId
{
    __block BOOL isSuccess = NO;
    
    [[FMDatabaseQueue instance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:@"DELETE FROM score WHERE term_id=?;", termId];
        
        for (XujcScore *score in scores) {
            isSuccess = [db executeUpdate:@"INSERT INTO score(name, term_id, credit, score, study_way, score_level, mid_term_status, end_term_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?);", score.courseName, termId, @(score.credit), @(score.score), score.studyWay, score.scoreLevel, score.midTermStatus, score.endTermStatus];
            if (!isSuccess) {
                *rollback = YES;
                return;
            }
        }
    }];
    return isSuccess;
}

- (NSArray<XujcTerm *> *)termsFormCache
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[FMDatabaseQueue instance] inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT id, name FROM term ORDER BY id DESC;";
        
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            XujcTerm *term = [[XujcTerm alloc] init];
            term.termId = [set objectForColumnName:@"id"];
            term.displayName = [set objectForColumnName:@"name"];
            [result addObject:term];
        }

        [set close];
    }];
    return result;
}

@end
