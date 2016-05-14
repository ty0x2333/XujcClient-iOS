//
//  PersonalHeaderViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalHeaderViewModel.h"
#import "EditableAvatarImageViewModel.h"
#import "UserModel.h"

@implementation PersonalHeaderViewModel

- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        RACSignal *userSignal = [[userDefaults ty_channelTerminalForUser] map:^id(NSData *value) {
            UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:value];
            return user;
        }];
        
        RAC(self, nickname) = [[[userSignal map:^id(UserModel *value) {
            return value.nikename;
        }] setNameWithFormat:@"PersonalHeaderViewModel nikenameSignal"] logAll];
        
        RAC(self, avatar) = [[[userSignal map:^id(UserModel *value) {
            return value.avatar;
        }] setNameWithFormat:@"PersonalHeaderViewModel avatarSignal"] logAll];
    }
    return self;
}

- (EditableAvatarImageViewModel *)editableAvatarImageViewModel
{
    return [[EditableAvatarImageViewModel alloc] init];
}

@end
