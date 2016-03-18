//
//  SettingsViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SettingsViewModel.h"
#import "UserModel.h"

@implementation SettingsViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _executeLoginout = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self executeLoginoutSignal];
        }];
    }
    return self;
}

- (RACSignal *)executeLoginoutSignal
{
    RACSignal *executeLoginoutSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:@"" forKey:kUserDefaultsKeyApiKey];
        [userDefaults setValue:@"" forKey:kUserDefaultsKeyXujcKey];
        [userDefaults setValue:[[[UserModel alloc] init] data] forKey:kUserDefaultsKeyUser];
        [userDefaults synchronize];
        return [RACDisposable disposableWithBlock:^{}];
    }];
    return [[executeLoginoutSignal setNameWithFormat:@"SettingsViewModel executeLoginoutSignal"] logAll];
}

#pragma mark - Private Helper

@end
