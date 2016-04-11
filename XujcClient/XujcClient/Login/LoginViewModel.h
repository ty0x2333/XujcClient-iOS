//
//  LoginViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/4.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AccountViewModel.h"
#import "BindingAccountViewModel.h"
#import "ChangePasswordViewModel.h"

@interface LoginViewModel : AccountViewModel

@property (strong, nonatomic) RACCommand *executeLogin;

@property (strong, nonatomic) RACSignal *loginActiveSignal;

- (NSString *)currentAccountPhone;
- (NSString *)currentAccountPassword;

- (ChangePasswordViewModel *)changePasswordViewModel;

@end
