//
//  LoginViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/4.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LoginViewModel.h"
#import "NSString+Validator.h"
#import "TYService.h"
#import <SSKeychain.h>
#import "UserModel.h"
#import "DynamicData.h"

NSString * const kLoginRequestDomain = @"LoginRequestDomain";

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _loginActiveSignal = [[self.validPhoneSignal combineLatestWith:self.validPasswordSignal]
                              reduceEach:^id(NSNumber *phoneValid, NSNumber *passwordValid) {
                                  return @([phoneValid boolValue] && [passwordValid boolValue]);
                              }];
        
        _executeLogin = [[RACCommand alloc] initWithEnabled:_loginActiveSignal signalBlock:^RACSignal *(id input) {
            return [self executeLoginSignal];
        }];
    }
    return self;
}

- (RACSignal *)executeLoginSignal
{
    return [self.sessionManager requestLoginSignalWithPhone:self.account andPassword:self.password];
}

- (NSString *)currentAccountPhone
{
    return DYNAMIC_DATA.user.phone;
}

- (NSString *)currentAccountPassword
{
    return [SSKeychain passwordForService:TYServiceName account:[self currentAccountPhone]];
}

- (ChangePasswordViewModel *)changePasswordViewModel
{
    return [[ChangePasswordViewModel alloc] init];
}

@end
