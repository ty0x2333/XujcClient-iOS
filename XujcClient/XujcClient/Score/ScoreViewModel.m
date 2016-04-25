//
//  ScoreViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreViewModel.h"
#import "XujcScoreModel.h"
#import "XujcService.h"
#import "DynamicData.h"
#import "CacheUtils.h"

@interface ScoreViewModel()

@property (strong, nonatomic) NSArray<XujcScoreModel *> *scores;

@end

@implementation ScoreViewModel

- (ScoreTableViewCellViewModel *)scoreTableViewCellViewModelForRowAtIndex:(NSUInteger)index
{
    XujcScoreModel *scoreModel = [_scores objectAtIndex:index];
    ScoreTableViewCellViewModel *cellViewModel = [[ScoreTableViewCellViewModel alloc] initWithModel:scoreModel];
    return cellViewModel;
}

- (RACSignal *)fetchScoresSignal
{
    NSString *semesterId = [self.semesterSelectorViewModel selectedSemesterId];
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        return [[self.xujcSessionManager requestScoresSignalWithSemesterId:semesterId] subscribeNext:^(NSArray *scores) {
            self.scores = scores;
            [subscriber sendNext:nil];
        } error:^(NSError *error) {
            self.semesters = [[CacheUtils instance] semestersFormCache];
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

- (NSInteger)scoreCount
{
    return [_scores count];
}

@end
