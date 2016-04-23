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
#import "CacheUtils.h"

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
            [subscriber sendError:error];
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
            [subscriber sendError:error];
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
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    signal.name = [NSString stringWithFormat:@"requestScoresSignalWithSemesterId: %@", semesterId];
    return [[signal replayLazily] ty_logAll];
}

@end
