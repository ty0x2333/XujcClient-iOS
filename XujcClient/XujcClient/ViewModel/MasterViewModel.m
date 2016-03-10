//
//  MasterViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "MasterViewModel.h"

static NSString * const kUserDefaultsKeyUser = @"user";

@implementation MasterViewModel

- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _apiKeyChangedSignal = [userDefaults rac_channelTerminalForKey:kUserDefaultsKeyApiKey];
    }
    return self;
}

- (void)setXujcKey:(NSString *)xujcKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[xujcKey copy] forKey:kUserDefaultsKeyXujcKey];
    [userDefaults synchronize];
}

- (MainTabBarViewModel *)mainTabBarViewModel
{
    return [[MainTabBarViewModel alloc] init];
}

@end
