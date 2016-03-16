//
//  MainTabBarViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "MainTabBarViewModel.h"

@interface MainTabBarViewModel()

@property (strong, nonatomic) SemesterMasterViewModel *semesterMasterViewModel;

@end

@implementation MainTabBarViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _semesterMasterViewModel = [[SemesterMasterViewModel alloc] init];
    }
    return self;
}

{
}

- (LoginViewModel *)loginViewModel
{
    return [[LoginViewModel alloc] init];
}

- (SignupViewModel *)signupViewModel
{
    return [[SignupViewModel alloc] init];
}

- (ScheduleViewModel *)scheduleViewModel
{
    return [self.semesterMasterViewModel scheduleViewModel];
}

- (ScoreViewModel *)scoreViewModel
{
    return [self.semesterMasterViewModel scoreViewModel];
}

- (BindingAccountViewModel *)bindingAccountViewModel
{
    return [[BindingAccountViewModel alloc] init];
}

@end
