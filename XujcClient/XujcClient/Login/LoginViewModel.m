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

@interface LoginViewModel()

@property (nonatomic, assign) BOOL isLoginActive;

@end

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        RAC(self, isLoginActive) = [[self.validPhoneSignal combineLatestWith:self.validPasswordSignal]
                                    reduceEach:^id(NSNumber *phoneValid, NSNumber *passwordValid) {
                                        return @([phoneValid boolValue] && [passwordValid boolValue]);
                                    }];
        RACSignal *loginActiveSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, password)] reduce:^id(NSString *phone, NSString *password){
            return @(![NSString isEmpty:phone] && ![NSString isEmpty:password]);
        }];
        @weakify(self);
        _executeLogin = [[RACCommand alloc] initWithEnabled:loginActiveSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            if (!self.isValidPhone) {
                return [RACSignal error:self.validPhoneError];
            }
            if (!self.isValidPassword) {
                return [RACSignal error:self.validPasswordError];
            }
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
