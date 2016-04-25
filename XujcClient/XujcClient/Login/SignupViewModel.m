//
//  SignupViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SignupViewModel.h"
#import <SSKeychain.h>
#import "TYService.h"
#import "UserModel.h"
#import "DynamicData.h"
#import "NSString+Validator.h"
#import "VerificationCodeTextFieldViewModel.h"
#import "ServiceProtocolViewModel.h"

static NSString * const kSignupRequestDomain = @"SignupRequestDomain";

@interface SignupViewModel()

@property (assign, nonatomic) NSInteger countdown;
@property (strong, nonatomic) VerificationCodeTextFieldViewModel *verificationCodeTextFieldViewModel;

@end

@implementation SignupViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _verificationCodeTextFieldViewModel = [[VerificationCodeTextFieldViewModel alloc] initWithType:VerificationCodeTypeSignUp];
        
        RACChannelTo(_verificationCodeTextFieldViewModel, phone) = RACChannelTo(self, account);
        
        _validNicknameSignal = [[RACObserve(self, nickname)
                                 map:^id(NSString *text) {
                                     return @([NSString ty_validateUsername:text]);
                                 }] distinctUntilChanged];
        
        _signupActiveSignal = [RACSignal combineLatest:@[self.validPhoneSignal, self.validPasswordSignal, self.validNicknameSignal, _verificationCodeTextFieldViewModel.validVerificationCodeSignal]
                                                reduce:^id(NSNumber *phoneValid, NSNumber *usernameValid, NSNumber *passwordValid, NSNumber *VerificationCodeValid) {
                                                    return @([phoneValid boolValue] && [usernameValid boolValue] && [passwordValid boolValue] && [VerificationCodeValid boolValue]);
                                                }];

        _executeSignup = [[RACCommand alloc] initWithEnabled:_signupActiveSignal signalBlock:^RACSignal *(id input) {
            TyLogDebug(@"executeSignup");
            return [[[self executeSignupSignal] setNameWithFormat:@"executeSignupSignal"] logAll];
        }];
    }
    return self;
}

- (RACSignal *)executeSignupSignal
{
    return [self.sessionManager requestSignupSignalWithPhone:self.account andPassword:self.password andName:self.nickname andVertificationCode:self.verificationCodeTextFieldViewModel.verificationCode];
}

- (ServiceProtocolViewModel *)serviceProtocolViewModel
{
    return [[ServiceProtocolViewModel alloc] init];
}

@end
