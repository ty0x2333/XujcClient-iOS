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
#import "NSError+Valid.h"

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
        
        RAC(self, isValidNickname) = [[RACObserve(self, nickname)
                                       map:^id(NSString *text) {
                                           return @([NSString ty_validateUsername:text]);
                                       }] distinctUntilChanged];
        
        RACSignal *signupActiveSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, password), RACObserve(self, nickname), RACObserve(self.verificationCodeTextFieldViewModel, verificationCode)]
                                                reduce:^id(NSString *phone, NSString *password, NSString *nickname, NSString *verificationCode) {
                                                    return @(![NSString isEmpty:phone] && ![NSString isEmpty:password] &&
                                                    ![NSString isEmpty:nickname] && ![NSString isEmpty:verificationCode]);
                                                }];

        @weakify(self);
        _executeSignup = [[RACCommand alloc] initWithEnabled:signupActiveSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            if (!self.isValidNickname) {
                return [RACSignal error:[NSError ty_validNickname]];
            }
            if (!self.isValidPhone) {
                return [RACSignal error:[NSError ty_validPhoneError]];
            }
            if (!self.verificationCodeTextFieldViewModel.isValidVerificationCode) {
                return [RACSignal error:[NSError ty_validVertificationCodeError]];
            }
            if (!self.isValidPassword) {
                return [RACSignal error:[NSError ty_validPasswordError]];
            }
            return [[[self executeSignupSignal] setNameWithFormat:@"executeSignupSignal"] ty_logAll];
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
