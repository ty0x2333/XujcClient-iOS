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
    RACSignal *fetchExamsSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"ksap.php" parameters:@{XujcServiceKeyApiKey: DYNAMIC_DATA.xujcKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *examDatas = responseObject;
            NSMutableArray *examModels = [[NSMutableArray alloc] initWithCapacity:examDatas.count];
            [examDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XujcExamModel *exam = [[XujcExamModel alloc] initWithJSONResopnse:obj];
                TyLogDebug(@"Exam: %@", exam);
                [examModels addObject:exam];
            }];
            self.exams = [examModels copy];
            
//            [[CacheUtils instance] cacheScore:[scoreModels copy] inSemester:semesterId];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger statusCode = ((NSHTTPURLResponse *)(task.response)).statusCode;
            if (statusCode == 400) {
                self.exams = nil;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
//                self.scores = [[CacheUtils instance] scoresFormCacheWithSemester:semesterId];
                
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [[fetchExamsSignal setNameWithFormat:@"fetchScoresSignal"] logAll];
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
