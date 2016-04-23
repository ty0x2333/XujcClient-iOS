//
//  ExamViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ExamViewModel.h"
#import "DynamicData.h"
#import "XujcExamModel.h"
#import "ExamTableViewCellViewModel.h"

@interface ExamViewModel()

@property (strong, nonatomic) NSArray<XujcExamModel *> *exams;

@end

@implementation ExamViewModel

- (RACSignal *)fetchExamsSignal
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        return [[self.xujcSessionManager requestExamsSignal] subscribeNext:^(NSArray *scores) {
            self.exams = scores;
            [subscriber sendNext:nil];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

- (NSUInteger)examCount
{
    return [_exams count];
}

- (ExamTableViewCellViewModel *)examTableViewCellViewModelForRowAtIndex:(NSUInteger)index
{
    XujcExamModel *model = [_exams objectAtIndex:index];
    ExamTableViewCellViewModel *cellViewModel = [[ExamTableViewCellViewModel alloc] initWithModel:model];
    return cellViewModel;
}

@end
