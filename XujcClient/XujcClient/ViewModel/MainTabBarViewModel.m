//
//  MainTabBarViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "MainTabBarViewModel.h"

@implementation MainTabBarViewModel

- (ScheduleViewModel *)scheduleViewModel
{
    return [[ScheduleViewModel alloc] init];
}

- (LoginViewModel *)loginViewModel
{
    return [[LoginViewModel alloc] init];
}

- (SignupViewModel *)signupViewModel
{
    return [[SignupViewModel alloc] init];
}

- (ScoreViewModel *)scoreViewModel
{
    return [[ScoreViewModel alloc] init];
}

- (BindingAccountViewModel *)bindingAccountViewModel
{
    return [[BindingAccountViewModel alloc] init];
}

@end
