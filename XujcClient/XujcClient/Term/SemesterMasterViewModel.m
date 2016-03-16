//
//  SemesterMasterViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterMasterViewModel.h"
#import "XujcSemesterModel.h"
#import "CacheUtils.h"
#import "XujcServer.h"
#import "DynamicData.h"

@interface SemesterMasterViewModel()

@property (strong, nonatomic) NSArray<XujcSemesterModel *> *semesters;

@end

@implementation SemesterMasterViewModel

- (RACSignal *)fetchSemestersSignal
{
    @weakify(self);
    RACSignal *fetchSemestersSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"kb.php" parameters:@{XujcServerKeyApiKey: DYNAMIC_DATA.xujcKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
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
            self.semesters = [semesterArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // load data from cache database
            self.semesters = [[CacheUtils instance] semestersFormCache];
            
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [[fetchSemestersSignal setNameWithFormat:@"fetchSemestersSignal"] logAll];
}

- (NSInteger)semesterCount
{
    return _semesters.count;
}

- (ScoreViewModel *)scoreViewModel
{
    ScoreViewModel *viewModel = [[ScoreViewModel alloc] init];
    RACChannelTo(viewModel, semesters) = RACChannelTo(self, semesters);
    return viewModel;
}

- (ScheduleViewModel *)scheduleViewModel
{
    ScheduleViewModel *viewModel = [[ScheduleViewModel alloc] init];
    RACChannelTo(viewModel, semesters) = RACChannelTo(self, semesters);
    return viewModel;
}

@end
