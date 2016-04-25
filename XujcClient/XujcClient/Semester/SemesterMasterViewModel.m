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
#import "XujcService.h"
#import "DynamicData.h"

@interface SemesterMasterViewModel()

@property (strong, nonatomic) NSArray<XujcSemesterModel *> *semesters;

@end

@implementation SemesterMasterViewModel

- (RACSignal *)fetchSemestersSignal
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        return [[self.xujcSessionManager requestSemestersSignal] subscribeNext:^(NSArray *semesters) {
            self.semesters = semesters;
            [subscriber sendNext:nil];
        } error:^(NSError *error) {
            self.semesters = [[CacheUtils instance] semestersFormCache];
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
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
