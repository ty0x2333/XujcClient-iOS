//
//  MasterViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "MasterViewModel.h"
#import "DynamicData.h"
#import "UserModel.h"
#import <Instabug/Instabug.h>

@implementation MasterViewModel

- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        RACSignal *shakingReportStatusSignal = [[[userDefaults ty_channelTerminalForShakingReportStatus] setNameWithFormat:@"MasterViewModel shakingReportStatusChannel"] logAll];
        [shakingReportStatusSignal subscribeNext:^(NSNumber *value) {
            [Instabug setInvocationEvent:[value boolValue] ? IBGInvocationEventShake : IBGInvocationEventNone];
        }];
        
        RACSignal *userSignal = [[[[userDefaults ty_channelTerminalForUser] map:^id(NSData *value) {
            UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:value];
            return user;
        }] setNameWithFormat:@"MasterViewModel userSignal"] logAll];

        [userSignal subscribeNext:^(UserModel *model) {
            [Instabug setUserEmail:model.email];
        }];
    }
    return self;
}

- (MainTabBarViewModel *)mainTabBarViewModel
{
    return [[MainTabBarViewModel alloc] init];
}

@end
