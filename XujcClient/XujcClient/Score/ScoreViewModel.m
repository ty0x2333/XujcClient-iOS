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

@interface ScoreViewModel()

@property (strong, nonatomic) NSArray<XujcScore *> *scores;

@end

@implementation ScoreViewModel

- (ScoreTableViewCellViewModel *)scoreTableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreTableViewCellViewModel *cellViewModel = [[ScoreTableViewCellViewModel alloc] init];
    XujcScore *scoreModel = [_scores objectAtIndex:indexPath.row];
    cellViewModel.xujcScoreModel = scoreModel;
    return cellViewModel;
}

- (RACSignal *)fetchScoresSignal
{
    RACSignal *fetchScoresSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
#warning test termId
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"score.php" parameters:@{XujcServerKeyApiKey: DYNAMIC_DATA.xujcKey, XujcServerKeyTermId: @"20151"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *scoreDatas = responseObject;
            NSMutableArray *scoreModels = [[NSMutableArray alloc] initWithCapacity:scoreDatas.count];
            [scoreDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XujcScore *xujcScore = [[XujcScore alloc] initWithJSONResopnse:obj];
                TyLogDebug(@"Score: %@", xujcScore);
                [scoreModels addObject:xujcScore];
            }];
            self.scores = [scoreModels copy];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
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
