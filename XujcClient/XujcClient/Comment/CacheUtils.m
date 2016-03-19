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
        
        NSString *semesterTableSQL = @"CREATE TABLE IF NOT EXISTS semester ("
                                 @"id integer PRIMARY KEY NOT NULL,"
                                 @"name text"
                                 @");";
        
        NSString *scoreTableSQL = @"CREATE TABLE IF NOT EXISTS score ("
                                  @"semester_id text NOT NULL,"
                                  @"name text NOT NULL,"
                                  @"credit integer,"
                                  @"score integer,"
                                  @"study_way text,"
                                  @"score_level text,"
                                  @"mid_semester_status text,"
                                  @"end_semester_status text,"
                                  @"PRIMARY KEY(semester_id, name)"
                                  @");";
        
        [db executeUpdate:semesterTableSQL];
        [db executeUpdate:scoreTableSQL];
    }];
}

- (BOOL)cacheSemesters:(NSArray<XujcSemesterModel *> *)semesters
{
    __block BOOL isSuccess = NO;
    
    [[FMDatabaseQueue instance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (XujcSemesterModel *semester in semesters) {
            isSuccess = [db executeUpdate:@"INSERT OR REPLACE INTO semester(id, name) VALUES (?, ?);", semester.semesterId, semester.displayName];
            if (!isSuccess) {
                *rollback = YES;
                return;
            }
        }
    }];
    return isSuccess;
}

- (BOOL)cacheScore:(NSArray<XujcScore *> *)scores inSemester:(NSString *)semesterId
{
    __block BOOL isSuccess = NO;
    
    [[FMDatabaseQueue instance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:@"DELETE FROM score WHERE semester_id=?;", semesterId];
        
        for (XujcScore *score in scores) {
            isSuccess = [db executeUpdate:@"INSERT INTO score(name, semester_id, credit, score, study_way, score_level, mid_semester_status, end_semester_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?);", score.lessonName, semesterId, @(score.credit), @(score.score), score.studyWay, score.scoreLevel, score.midSemesterStatus, score.endSemesterStatus];
            if (!isSuccess) {
                *rollback = YES;
                return;
            }
        }
    }];
    return isSuccess;
}

- (NSArray<XujcSemesterModel *> *)semestersFormCache
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[FMDatabaseQueue instance] inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT id, name FROM semester ORDER BY id DESC;";
        
        FMResultSet *set = [db executeQuery:sql];
        
        while ([set next]) {
            XujcSemesterModel *semester = [[XujcSemesterModel alloc] init];
            semester.semesterId = [set objectForColumnName:@"id"];
            semester.displayName = [set objectForColumnName:@"name"];
            [result addObject:semester];
        }

        [set close];
    }];
    return result;
}

- (NSArray<XujcScore *> *)scoresFormCacheWithSemester:(NSString *)semesterId
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[FMDatabaseQueue instance] inDatabase:^(FMDatabase *db) {
        NSString *sqlFormat = @"SELECT name, credit, score, study_way, score_level, mid_semester_status, end_semester_status FROM score WHERE semester_id=?;";
        
        FMResultSet *set = [db executeQuery:sqlFormat, semesterId];
        
        while ([set next]) {
            XujcScore *score = [[XujcScore alloc] init];
            score.lessonName = [set objectForColumnName:@"name"];
            score.credit = [[set objectForColumnName:@"credit"] integerValue];
            score.score = [[set objectForColumnName:@"score"] integerValue];
            score.studyWay = [set objectForColumnName:@"study_way"];
            score.scoreLevel = [set objectForColumnName:@"score_level"];
            score.midSemesterStatus = [set objectForColumnName:@"mid_semester_status"];
            score.endSemesterStatus = [set objectForColumnName:@"end_semester_status"];
            [result addObject:score];
        }
        
        [set close];
    }];
    return result;
}

@end
