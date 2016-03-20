//
//  MasterViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "MasterViewModel.h"
#import "DynamicData.h"
#import <Instabug/Instabug.h>

@implementation MasterViewModel

- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        RACSignal *shakingReportStatusSignal = [[[userDefaults rac_channelTerminalForKey:kUserDefaultsKeyShakingReportStatus] setNameWithFormat:@"MasterViewModel shakingReportStatusChannel"] logAll];
        [shakingReportStatusSignal subscribeNext:^(NSNumber *value) {
            [Instabug setInvocationEvent:[value boolValue] ? IBGInvocationEventShake : IBGInvocationEventNone];
        }];
    }
    return self;
}

- (MainTabBarViewModel *)mainTabBarViewModel
{
    return [[MainTabBarViewModel alloc] init];
}

@end
