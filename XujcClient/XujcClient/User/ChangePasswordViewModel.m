//
//  ChangePasswordViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ChangePasswordViewModel.h"
#import "NSString+Validator.h"
#import "TYService.h"
#import "NSError+Valid.h"

static NSString * const kChangePasswordRequestDomain = @"ChangePasswordRequestDomain";

@interface ChangePasswordViewModel()

@property (nonatomic, strong) VerificationCodeTextFieldViewModel *verificationCodeTextFieldViewModel;

@end

@implementation ChangePasswordViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _verificationCodeTextFieldViewModel = [[VerificationCodeTextFieldViewModel alloc] initWithType:VerificationCodeTypeChangePasswordUp];
        RACChannelTo(_verificationCodeTextFieldViewModel, phone) = RACChannelTo(self, phone);
        
        RACSignal *changePasswordActiveSignal = [RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, password), RACObserve(self.verificationCodeTextFieldViewModel, verificationCode)]
                                                reduce:^id(NSString *phone, NSString *password, NSString *verificationCode) {
                                                    return @(![NSString isEmpty:phone] && ![NSString isEmpty:password] && ![NSString isEmpty:verificationCode]);
                                                }];
        _executeChangePassword = [[RACCommand alloc] initWithEnabled:changePasswordActiveSignal signalBlock:^RACSignal *(id input) {
            if (![NSString ty_validatePhone:self.phone]) {
                return [RACSignal error:[NSError ty_validPhoneError]];
            }
            if (!self.verificationCodeTextFieldViewModel.isValidVerificationCode) {
                return [RACSignal error:[NSError ty_validVertificationCodeError]];
            }
            if (![NSString ty_validatePassword:self.password]) {
                return [RACSignal error:[NSError ty_validPasswordError]];
            }
            return [self executeChangePasswordSignal];
        }];
    }
    return self;
}

- (RACSignal *)executeChangePasswordSignal
{
    return [self.sessionManager requestChangePasswordSignalWithPhone:self.phone andPassword:self.password andVertificationCode:self.verificationCodeTextFieldViewModel.verificationCode];
}

@end
