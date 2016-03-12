//
//  ScoreViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TermBaseViewModel.h"
#import "ScoreTableViewCellViewModel.h"

@interface ScoreViewModel : TermBaseViewModel

@property (strong, nonatomic) RACSignal *fetchScoresSignal;

- (NSInteger)scoreCount;

- (ScoreTableViewCellViewModel *)scoreTableViewCellViewModelForRowAtIndex:(NSUInteger)index;

@end
