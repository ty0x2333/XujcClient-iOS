//
//  ChangePasswordViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ChangePasswordViewModel.h"
#import "NSString+Validator.h"

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
        
        _changePasswordActiveSignal = [RACSignal combineLatest:@[validPhoneSignal, validPasswordSignal]
                                                reduce:^id(NSNumber *phoneValid, NSNumber *passwordValid) {
                                                    return @([phoneValid boolValue] && [passwordValid boolValue]);
                                                }];
        _executeChangePassword = [[RACCommand alloc] initWithEnabled:_changePasswordActiveSignal signalBlock:^RACSignal *(id input) {
//            return [[[self executeChangePasswordSignal] setNameWithFormat:@"executeChangePasswordSignal"] logAll];
            return [RACSignal empty];
        }];
    }
    return self;
}

//- (RACSignal *)executeChangePasswordSignal
//{
//    @weakify(self);
//    RACSignal *executeChangePasswordSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self);
//        NSURLSessionDataTask *task = [self.sessionManager POST:@"register" parameters:@{TYServiceKeyNickname: self.nickname, TYServiceKeyPhone: self.account, TYServiceKeyPassword: self.password, TYServiceKeyVerificationCode: self.verificationCodeTextFieldViewModel.verificationCode} progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *responseObject) {
//            BOOL isError = [[responseObject objectForKey:TYServiceKeyError] boolValue];
//            NSString *message = [responseObject objectForKey:TYServiceKeyMessage];
//            if (isError) {
//                NSError *error = [NSError errorWithDomain:kSignupRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
//                [subscriber sendError:error];
//            } else {
//                [subscriber sendNext:message];
//                [subscriber sendCompleted];
//            }
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [subscriber sendError:error];
//        }];
//        return [RACDisposable disposableWithBlock:^{
//            [task cancel];
//        }];
//    }];
//    return executeSignupSignal;
//}

@end
