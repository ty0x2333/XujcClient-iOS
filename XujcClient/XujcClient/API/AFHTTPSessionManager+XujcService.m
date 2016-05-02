//
//  AFHTTPSessionManager+XujcService.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AFHTTPSessionManager+XujcService.h"
#import "DynamicData.h"
#import "XujcSemesterModel.h"
#import "XujcUserModel.h"
#import "XujcExamModel.h"
#import "XujcLessonModel.h"
#import "CacheUtils.h"
#import "RACSignal+TYDebugging.h"
#import "NSError+XujcService.h"
#import "XujcServiceKeys.h"

static NSString* const kXujcServiceHost = @"http://jw.xujc.com/api/";

@implementation AFHTTPSessionManager (XujcService)

+ (instancetype)xujc_manager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[kXujcServiceHost copy]]];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    manager.requestSerializer.stringEncoding = encoding;
    return manager;
}

- (RACSignal *)requestSemestersSignal
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self GET:@"kb.php" parameters:@{XujcServiceKeyApiKey: DYNAMIC_DATA.xujcKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *semesterIds = [responseObject allKeys];
            NSMutableArray *semesterArray = [NSMutableArray arrayWithCapacity:semesterIds.count];
            for (id key in semesterIds) {
                XujcSemesterModel *semester = [[XujcSemesterModel alloc] init];
                semester.semesterId = key;
                semester.displayName = responseObject[key];
                [semesterArray addObject:semester];
            }
            
            [[CacheUtils instance] cacheSemesters:semesterArray];
            
            // sort DESC
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"semesterId" ascending:NO];
            
            [subscriber sendNext:[semesterArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]]];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([[self class] p_cleanXujcKeyIfNeedWithTask:task]) {
                [subscriber sendError:[NSError xujc_authenticationError]];
            } else {
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    signal.name = @"requestSemestersSignal";
    return [[signal replayLazily] ty_logAll];
}

- (RACSignal *)requestUserInformationSignalWithXujcKey:(NSString *)xujcKey
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self GET:@"me.php" parameters:@{XujcServiceKeyApiKey: xujcKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            XujcUserModel *user = [[XujcUserModel alloc] initWithJSONResopnse:responseObject];
            [subscriber sendNext:user];
            [subscriber sendCompleted];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([[self class] p_cleanXujcKeyIfNeedWithTask:task]) {
                [subscriber sendError:[NSError xujc_authenticationError]];
            } else {
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    signal.name = [NSString stringWithFormat:@"requestUserInformationSignalWithXujcKey: %@", xujcKey];
    return [[signal replayLazily] ty_logAll];
}

- (RACSignal *)requestScoresSignalWithSemesterId:(NSString *)semesterId
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self GET:@"score.php" parameters:@{XujcServiceKeyApiKey: DYNAMIC_DATA.xujcKey, XujcServiceKeySemesterId: semesterId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray *scoreDatas = responseObject;
            NSMutableArray *scoreModels = [[NSMutableArray alloc] initWithCapacity:scoreDatas.count];
            [scoreDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XujcScoreModel *xujcScore = [[XujcScoreModel alloc] initWithJSONResopnse:obj];
                [scoreModels addObject:xujcScore];
            }];
            [[CacheUtils instance] cacheScore:scoreModels inSemester:semesterId];
            
            [subscriber sendNext:[scoreModels copy]];
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
            if ([[self class] p_cleanXujcKeyIfNeedWithTask:task]) {
                [subscriber sendError:[NSError xujc_authenticationError]];
            } else if (statusCode == 400){
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    signal.name = [NSString stringWithFormat:@"requestScoresSignalWithSemesterId: %@", semesterId];
    return [[signal replayLazily] ty_logAll];
}

- (RACSignal *)requestScheduleLessonSignalWithSemesterId:(NSString *)semesterId
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self GET:@"kb.php" parameters:@{XujcServiceKeyApiKey: DYNAMIC_DATA.xujcKey, XujcServiceKeySemesterId: semesterId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSMutableArray *lessonEventArray = [NSMutableArray arrayWithCapacity:[responseObject count]];
            
            for (id item in responseObject) {
                XujcLessonModel *lesson = [[XujcLessonModel alloc] initWithJSONResopnse:item];
                for (XujcLessonEventModel* event in lesson.lessonEvents) {
                    [lessonEventArray addObject:event];
                }
            }
            
            [[CacheUtils instance] cacheLessonEvent:lessonEventArray inSemester:semesterId];

            [subscriber sendNext:lessonEventArray];
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([[self class] p_cleanXujcKeyIfNeedWithTask:task]) {
                [subscriber sendError:[NSError xujc_authenticationError]];
            } else {
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    signal.name = [NSString stringWithFormat:@"requestScheduleLessonSignalWithSemesterId: %@", semesterId];
    return [[signal replayLazily] ty_logAll];
}

- (RACSignal *)requestExamsSignal
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self GET:@"ksap.php" parameters:@{XujcServiceKeyApiKey: DYNAMIC_DATA.xujcKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray *examDatas = responseObject;
                NSMutableArray *examModels = [[NSMutableArray alloc] initWithCapacity:examDatas.count];
                [examDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    XujcExamModel *exam = [[XujcExamModel alloc] initWithJSONResopnse:obj];
                    [examModels addObject:exam];
                }];
                [subscriber sendNext:examModels];
            } else {
                [subscriber sendNext:nil];
            }
            
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([[self class] p_cleanXujcKeyIfNeedWithTask:task]) {
                [subscriber sendError:[NSError xujc_authenticationError]];
            } else {
                [subscriber sendError:error];
            }
            
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    signal.name = @"requestExamsSignal";
    return [[signal replayLazily] ty_logAll];
}

#pragma mark - Helper

+ (BOOL)p_cleanXujcKeyIfNeedWithTask:(NSURLSessionDataTask *)task
{
    if (![[self class] p_xujc_isAuthenticationError:task]) {
        return NO;
    }
    [DYNAMIC_DATA cleanXujcKey];
    return YES;
}

+ (BOOL)p_xujc_isAuthenticationError:(NSURLSessionDataTask *)task
{
    if (![task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return NO;
    }
    NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
    return statusCode == 401 || statusCode == 403;
}

@end
