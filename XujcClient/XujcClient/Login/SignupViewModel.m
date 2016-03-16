//
//  SignupViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SignupViewModel.h"
#import <SSKeychain.h>
#import "TYServer.h"
#import "UserModel.h"
#import "DynamicData.h"
#import "NSString+Validator.h"

static NSString * const kSignupRequestDomain = @"SignupRequestDomain";

@implementation SignupViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _validNicknameSignal = [[RACObserve(self, nickname)
                                 map:^id(NSString *text) {
                                     return @([NSString ty_validateUsername:text]);
                                 }] distinctUntilChanged];
        
        _signupActiveSignal = [RACSignal combineLatest:@[self.validEmailSignal, self.validPasswordSignal, self.validNicknameSignal]
                                                reduce:^id(NSNumber *emailValid, NSNumber *usernameValid, NSNumber *passwordValid) {
                                                    return @([emailValid boolValue] && [usernameValid boolValue] && [passwordValid boolValue]);
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
        
        NSURLSessionDataTask *task = [self.sessionManager POST:@"register" parameters:@{TYServerKeyNickname: self.nickname, TYServerKeyEmail: self.account, TYServerKeyPassword: self.password} progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *responseObject) {
            BOOL isError = [[responseObject objectForKey:TYServerKeyError] boolValue];
            NSString *message = [responseObject objectForKey:TYServerKeyMessage];
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

@end