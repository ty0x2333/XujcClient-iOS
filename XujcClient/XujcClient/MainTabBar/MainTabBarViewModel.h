//
//  MainTabBarViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewModel.h"
#import "SignupViewModel.h"
#import "SemesterMasterViewModel.h"
#import "PersonalViewModel.h"

@interface MainTabBarViewModel : NSObject

@property (strong, nonatomic) RACSignal *apiActiveKeySignal;

@property (strong, nonatomic) RACSignal *apiKeyInactiveSignal;

@property (strong, nonatomic) RACSignal *xujcKeyInactiveSignal;

- (LoginViewModel *)loginViewModel;

- (SignupViewModel *)signupViewModel;

- (ScoreViewModel *)scoreViewModel;

- (ScheduleViewModel *)scheduleViewModel;

- (BindingAccountViewModel *)bindingAccountViewModel;

- (PersonalViewModel *)personalViewModel;

@end
