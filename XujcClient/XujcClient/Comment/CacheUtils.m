//
//  CacheUtils.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "CacheUtils.h"
#import "FMDatabaseQueue+Utils.h"

static NSString * const kSemesterTableInitSQL = @"CREATE TABLE IF NOT EXISTS semester ("
                                                @"id integer PRIMARY KEY NOT NULL,"
                                                @"name text"
                                                @");";

static NSString * const kScoreTableInitSQL = @"CREATE TABLE IF NOT EXISTS score ("
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

static NSString * const kLessonEventTableInitSQL = @"CREATE TABLE IF NOT EXISTS lesson_event ("
                                                   @"semester_id text NOT NULL,"
                                                   @"name text NOT NULL,"
                                                   @"lesson_class_id text,"
                                                   @"description text,"
                                                   @"study_day text,"
                                                   @"week_interval text,"
                                                   @"start_section integer,"
                                                   @"end_section integer,"
                                                   @"start_week integer,"
                                                   @"end_week integer,"
                                                   @"location text"
                                                   @");";

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
        
        [db executeUpdate:kSemesterTableInitSQL];
        [db executeUpdate:kScoreTableInitSQL];
        [db executeUpdate:kLessonEventTableInitSQL];
    }];
}

- (void)cleanCache
{
    [[FMDatabaseQueue instance] inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM semester"];
        [db executeUpdate:@"DELETE FROM score"];
        [db executeUpdate:@"DELETE FROM lesson_event"];
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

- (BOOL)cacheLessonEvent:(NSArray<XujcLessonEventModel *> *)lessonEvents inSemester:(NSString *)semesterId
{
    __block BOOL isSuccess = NO;
    
    [[FMDatabaseQueue instance] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:@"DELETE FROM lesson_event WHERE semester_id=?;", semesterId];

        for (XujcLessonEventModel *event in lessonEvents) {
            isSuccess = [db executeUpdate:@"INSERT INTO lesson_event(semester_id, name, lesson_class_id, description, study_day, week_interval, start_section, end_section, start_week, end_week, location) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", semesterId, event.name, event.lessonClassId, event.eventDescription, event.studyDay, event.weekInterval, @(event.startSection.sectionNumber), @(event.endSection.sectionNumber), @(event.startWeek), @(event.endWeek), event.location];
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

- (NSArray<XujcLessonEventModel *> *)lessonEventFormCacheWithSemester:(NSString *)semesterId
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [[FMDatabaseQueue instance] inDatabase:^(FMDatabase *db) {
        NSString *sqlFormat = @"SELECT name, lesson_class_id, description, study_day, week_interval, start_section, end_section, start_week, end_week, location FROM lesson_event WHERE semester_id=?;";
        
        FMResultSet *set = [db executeQuery:sqlFormat, semesterId];
        
        while ([set next]) {
            XujcLessonEventModel *event = [[XujcLessonEventModel alloc] init];
            event.name = [set objectForColumnName:@"name"];
            event.lessonClassId = [set objectForColumnName:@"lesson_class_id"];
            event.eventDescription = [set objectForColumnName:@"description"];
            event.studyDay = [set objectForColumnName:@"study_day"];
            event.weekInterval = [set objectForColumnName:@"week_interval"];
            [event setStartSectionWithSectionNumbser:[[set objectForColumnName:@"start_section"] integerValue]];
            [event setEndSectionWithSectionNumbser:[[set objectForColumnName:@"end_section"] integerValue]];
            event.startWeek = [[set objectForColumnName:@"start_week"] integerValue];
            event.endWeek = [[set objectForColumnName:@"end_week"] integerValue];
            event.location = [set objectForColumnName:@"location"];
            
            [result addObject:event];
        }
        
        [set close];
    }];
    return result;
}

@end
