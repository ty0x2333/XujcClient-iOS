//
//  SemesterBaseViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterBaseViewModel.h"

@interface SemesterBaseViewModel()

@property (strong, nonatomic) SemesterSelectorViewModel *semesterSelectorViewModel;

@end

@implementation SemesterBaseViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _semesterSelectorViewModel = [[SemesterSelectorViewModel alloc] init];
        RACChannelTo(_semesterSelectorViewModel, semesters) = RACChannelTo(self, semesters);
    }
    return self;
}

@end
