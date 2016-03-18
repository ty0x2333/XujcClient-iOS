//
//  PersonalViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalViewModel.h"

@implementation PersonalViewModel

- (PersonalHeaderViewModel *)personalHeaderViewModel
{
    return [[PersonalHeaderViewModel alloc] init];
}

- (SettingsViewModel *)settingsViewModel
{
    return [[SettingsViewModel alloc] init];
}

@end
