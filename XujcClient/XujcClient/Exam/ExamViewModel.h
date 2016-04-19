//
//  ExamViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
@class ExamTableViewCellViewModel;

@interface ExamViewModel : RequestViewModel

@property (strong, nonatomic) RACSignal *fetchExamsSignal;

- (NSUInteger)examCount;

- (ExamTableViewCellViewModel *)examTableViewCellViewModelForRowAtIndex:(NSUInteger)index;

@end
