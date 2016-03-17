//
//  PersonalHeaderViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalHeaderViewModel.h"
#import "UserModel.h"
#import "OssService.h"

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
        
        RAC(self, avater) = [userSignal map:^id(UserModel *value) {
            return value.avatar;
        }];
    }
    return self;
}

- (RACSignal *)updateAvatarSignalWithImage:(UIImage *)image
{
    return [OssService updateAvatarSignalWithImage:image];
}

@end
