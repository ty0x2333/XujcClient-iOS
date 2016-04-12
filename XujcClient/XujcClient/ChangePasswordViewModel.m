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
        _verificationCodeTextFieldViewModel = [[VerificationCodeTextFieldViewModel alloc] init];
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
            return [[[self executeChangePasswordSignal] setNameWithFormat:@"executeChangePasswordSignal"] logAll];
        }];
    }
    return self;
}

- (RACSignal *)executeChangePasswordSignal
{
    @weakify(self);
    RACSignal *executeChangePasswordSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self.sessionManager PUT:@"password" parameters:@{TYServiceKeyPhone: self.phone, TYServiceKeyPassword: self.password, TYServiceKeyVerificationCode: self.verificationCodeTextFieldViewModel.verificationCode} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            BOOL isError = [[responseObject objectForKey:TYServiceKeyError] boolValue];
            NSString *message = [responseObject objectForKey:TYServiceKeyMessage];
            if (isError) {
                NSError *error = [NSError errorWithDomain:kChangePasswordRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
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
    return executeChangePasswordSignal;
}

@end
