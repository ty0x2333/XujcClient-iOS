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
        _verificationCodeTextFieldViewModel = [[VerificationCodeTextFieldViewModel alloc] init];
        
        RACChannelTo(_verificationCodeTextFieldViewModel, phone) = RACChannelTo(self, account);
        
        _validNicknameSignal = [[RACObserve(self, nickname)
                                 map:^id(NSString *text) {
                                     return @([NSString ty_validateUsername:text]);
                                 }] distinctUntilChanged];
        
        _signupActiveSignal = [RACSignal combineLatest:@[self.validPhoneSignal, self.validPasswordSignal, self.validNicknameSignal]
                                                reduce:^id(NSNumber *phoneValid, NSNumber *usernameValid, NSNumber *passwordValid) {
                                                    return @([phoneValid boolValue] && [usernameValid boolValue] && [passwordValid boolValue]);
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
    @weakify(self);
    RACSignal *executeSignupSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self.sessionManager POST:@"register" parameters:@{TYServiceKeyNickname: self.nickname, TYServiceKeyPhone: self.account, TYServiceKeyPassword: self.password, TYServiceKeyVerificationCode: self.verificationCodeTextFieldViewModel.verificationCode} progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *responseObject) {
            BOOL isError = [[responseObject objectForKey:TYServiceKeyError] boolValue];
            NSString *message = [responseObject objectForKey:TYServiceKeyMessage];
            if (isError) {
                NSError *error = [NSError errorWithDomain:kSignupRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:message];
                [subscriber sendCompleted];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return executeSignupSignal;
}

- (ServiceProtocolViewModel *)serviceProtocolViewModel
{
    return [[ServiceProtocolViewModel alloc] init];
}

@end
