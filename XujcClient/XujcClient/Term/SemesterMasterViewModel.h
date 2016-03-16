//
//  SemesterMasterViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "ScoreViewModel.h"
#import "ScheduleViewModel.h"

@interface SemesterMasterViewModel : RequestViewModel

@property (strong, nonatomic) RACSignal *fetchSemestersSignal;

- (ScoreViewModel *)scoreViewModel;

- (ScheduleViewModel *)scheduleViewModel;

@end
