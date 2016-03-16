//
//  ScoreViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreViewModel.h"
#import "XujcScore.h"
#import "XujcServer.h"
#import "DynamicData.h"
#import "CacheUtils.h"

@interface ScoreViewModel()

@property (strong, nonatomic) NSArray<XujcScore *> *scores;

@end

@implementation ScoreViewModel

- (ScoreTableViewCellViewModel *)scoreTableViewCellViewModelForRowAtIndex:(NSUInteger)index
{
    ScoreTableViewCellViewModel *cellViewModel = [[ScoreTableViewCellViewModel alloc] init];
    XujcScore *scoreModel = [_scores objectAtIndex:index];
    cellViewModel.xujcScoreModel = scoreModel;
    return cellViewModel;
}

- (RACSignal *)fetchScoresSignal
{
    RACSignal *fetchScoresSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *semesterId = [self.semesterSelectorViewModel selectedSemesterId];
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"score.php" parameters:@{XujcServerKeyApiKey: DYNAMIC_DATA.xujcKey, XujcServerKeySemesterId: semesterId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *scoreDatas = responseObject;
            NSMutableArray *scoreModels = [[NSMutableArray alloc] initWithCapacity:scoreDatas.count];
            [scoreDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XujcScore *xujcScore = [[XujcScore alloc] initWithJSONResopnse:obj];
                TyLogDebug(@"Score: %@", xujcScore);
                [scoreModels addObject:xujcScore];
            }];
            self.scores = [scoreModels copy];
            
            [[CacheUtils instance] cacheScore:[scoreModels copy] inSemester:semesterId];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger statusCode = ((NSHTTPURLResponse *)(task.response)).statusCode;
            if (statusCode == 400) {
                self.scores = nil;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } else {
                self.scores = [[CacheUtils instance] scoresFormCacheWithSemester:semesterId];
                
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [[fetchScoresSignal setNameWithFormat:@"fetchScoresSignal"] logAll];
}

- (NSInteger)scoreCount
{
    return [_scores count];
}

@end
