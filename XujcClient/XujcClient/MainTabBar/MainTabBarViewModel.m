//
//  MainTabBarViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "MainTabBarViewModel.h"

@interface MainTabBarViewModel()

@property (strong, nonatomic) RACSignal *xujcActiveKeySignal;

@property (strong, nonatomic) SemesterMasterViewModel *semesterMasterViewModel;

@end

@implementation MainTabBarViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _semesterMasterViewModel = [[SemesterMasterViewModel alloc] init];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        RACSignal *apiKeySignal = [userDefaults rac_channelTerminalForKey:kUserDefaultsKeyApiKey];
        RACSignal *xujcKeySignal = [userDefaults rac_channelTerminalForKey:kUserDefaultsKeyXujcKey];
        
        _apiActiveKeySignal = [[[apiKeySignal filter:^BOOL(NSString *value) {
            return ![NSString isEmpty:value];
        }] setNameWithFormat:@"MainTabBarViewModel apiActiveKeySignal"] logAll];
        
        _xujcActiveKeySignal = [[[xujcKeySignal filter:^BOOL(NSString *value) {
            return ![NSString isEmpty:value];
        }] setNameWithFormat:@"MainTabBarViewModel xujcKeySignal"] logAll];
        
        _apiKeyInactiveSignal = [[[apiKeySignal filter:^BOOL(NSString *value) {
            return [NSString isEmpty:value];
        }] setNameWithFormat:@"MainTabBarViewModel apiKeyInactiveSignal"] logAll];
        
        _xujcKeyInactiveSignal = [[[xujcKeySignal filter:^BOOL(NSString *value) {
            return [NSString isEmpty:value];
        }] setNameWithFormat:@"MainTabBarViewModel xujcKeyInactiveSignal"] logAll];
        
        @weakify(self);
        [_xujcActiveKeySignal subscribeNext:^(id x) {
            @strongify(self);
            [self.semesterMasterViewModel.fetchSemestersSignal subscribeCompleted:^{
                
            }];
        }];
    }
    return self;
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
