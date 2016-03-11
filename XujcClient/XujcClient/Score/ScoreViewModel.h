//
//  ScoreViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "ScoreTableViewCellViewModel.h"

@interface ScoreViewModel : RequestViewModel

@property (strong, nonatomic) RACSignal *fetchScoresSignal;

- (NSInteger)scoreCount;

- (ScoreTableViewCellViewModel *)scoreTableViewCellViewModelForRowAtIndex:(NSUInteger)index;

@end
