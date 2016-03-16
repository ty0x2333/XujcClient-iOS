//
//  PersonalHeaderViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalHeaderViewModel.h"
#import "UserModel.h"

@implementation PersonalHeaderViewModel

- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        RACSignal *userSignal = [[[[userDefaults rac_channelTerminalForKey:kUserDefaultsKeyUser] map:^id(NSData *value) {
            UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:value];
            return user;
        }] setNameWithFormat:@"PersonalHeaderViewModel userSignal"] logAll];
        
        RAC(self, nickname) = [userSignal map:^id(UserModel *value) {
            return value.nikename;
        }];
    }
    return self;
}

@end
