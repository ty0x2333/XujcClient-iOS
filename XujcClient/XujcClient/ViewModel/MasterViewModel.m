//
//  MasterViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "MasterViewModel.h"

static NSString* const kUserDefaultsKeyApiKey = @"api_key";

@implementation MasterViewModel

- (void)setApiKey:(NSString *)apiKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[apiKey copy] forKey:kUserDefaultsKeyApiKey];
    [userDefaults synchronize];
}

- (NSString *)apiKey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyApiKey];
}

- (MainTabBarViewModel *)mainTabBarViewModel
{
    return [[MainTabBarViewModel alloc] init];
}

@end
