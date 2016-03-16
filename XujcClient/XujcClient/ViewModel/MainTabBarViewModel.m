//
//  MainTabBarViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "MainTabBarViewModel.h"

@interface MainTabBarViewModel()

@property (strong, nonatomic) RACSignal *apiActiveKeySignal;

@property (strong, nonatomic) RACSignal *didBecomeActiveSignal;

@property (strong, nonatomic) SemesterMasterViewModel *semesterMasterViewModel;

@end

@implementation MainTabBarViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _semesterMasterViewModel = [[SemesterMasterViewModel alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        RACSignal *apiKeySignal = [userDefaults rac_channelTerminalForKey:kUserDefaultsKeyApiKey];
        _apiActiveKeySignal = [[[apiKeySignal filter:^BOOL(NSString *value) {
            return ![NSString isEmpty:value];
        }] setNameWithFormat:@"MainTabBarViewModel apiActiveKeySignal"] logAll];
        
        
        _apiKeyInactiveSignal = [[[apiKeySignal filter:^BOOL(NSString *value) {
            return [NSString isEmpty:value];
        }] setNameWithFormat:@"MainTabBarViewModel apiKeyInactiveSignal"] logAll];
    }
    return self;
}

- (RACSignal *)didBecomeActiveSignal
{
    if (_didBecomeActiveSignal == nil) {
        @weakify(self);
        _didBecomeActiveSignal = [[[RACObserve(self, active)
                                    filter:^(NSNumber *active) {
                                        return active.boolValue;
                                    }]
                                   map:^(id _) {
                                       @strongify(self);
                                       return self;
                                   }]
                                  setNameWithFormat:@"%@ -didBecomeActiveSignal", self];
    }
    
    return _didBecomeActiveSignal;
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
