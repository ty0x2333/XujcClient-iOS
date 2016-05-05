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
#import "UMessage.h"

@implementation MasterViewModel

- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        RACSignal *shakingReportStatusSignal = [[[userDefaults ty_channelTerminalForShakingReportStatus] setNameWithFormat:@"MasterViewModel shakingReportStatusChannel"] ty_logNext];
        [shakingReportStatusSignal subscribeNext:^(NSNumber *value) {
            [Instabug setInvocationEvent:[value boolValue] ? IBGInvocationEventShake : IBGInvocationEventNone];
        }];
        
        RACSignal *userSignal = [[[[[userDefaults ty_channelTerminalForUser] ignore:nil] map:^id(NSData *value) {
            UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:value];
            return user;
        }] setNameWithFormat:@"MasterViewModel userSignal"] ty_logNext];
        
        [userSignal subscribeNext:^(UserModel *model) {
//            [Instabug setUserEmail:model.email];
            [Instabug setUserName:model.nikename];
        }];
        
        RACSignal *deviceTokenSignal = RACObserve(self, deviceToken);
        
        RACSignal *deviceTokenActiveSignal = [deviceTokenSignal ignore:nil];
        
        [deviceTokenSignal subscribeNext:^(NSData *data) {
            [UMessage registerDeviceToken:data];
        }];
        
        RACSignal *userPhoneSignal = [[[userSignal map:^id(UserModel *model) {
            return model.phone;
        }] filter:^BOOL(id value) {
            return [value isKindOfClass:[NSString class]] && (value != nil);
        }] distinctUntilChanged];
        
        [[RACSignal combineLatest:@[deviceTokenActiveSignal, userPhoneSignal] reduce:^id(NSData *data, NSString *phone){
            return phone;
        }] subscribeNext:^(NSString *phone) {
            [UMessage setAlias:phone type:@"TYService" response:^(id responseObject, NSError *error) {
                if (error) {
                    TyLogFatal(@"%@", error);
                }
            }];
        }];
    }
    return self;
}

- (MainTabBarViewModel *)mainTabBarViewModel
{
    return [[MainTabBarViewModel alloc] init];
}

@end
