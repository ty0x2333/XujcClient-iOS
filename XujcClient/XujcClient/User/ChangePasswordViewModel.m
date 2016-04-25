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
        
        RACSignal *validPhoneSignal = [[RACObserve(self, phone)
                              map:^id(NSString *text) {
                                  return @([NSString ty_validatePhone:text]);
                              }] distinctUntilChanged];
        
        RACSignal *validPasswordSignal = [[RACObserve(self, password)
                                 map:^id(NSString *text) {
                                     return @([NSString ty_validatePassword:text]);
                                 }] distinctUntilChanged];
        
        _changePasswordActiveSignal = [RACSignal combineLatest:@[validPhoneSignal, validPasswordSignal, _verificationCodeTextFieldViewModel.validVerificationCodeSignal]
                                                reduce:^id(NSNumber *phoneValid, NSNumber *passwordValid, NSNumber *verificationCodeValid) {
                                                    return @([phoneValid boolValue] && [passwordValid boolValue] && [verificationCodeValid boolValue]);
                                                }];
        _executeChangePassword = [[RACCommand alloc] initWithEnabled:_changePasswordActiveSignal signalBlock:^RACSignal *(id input) {
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
