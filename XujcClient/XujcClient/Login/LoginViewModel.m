//
//  LoginViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/4.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LoginViewModel.h"
#import "NSString+Validator.h"
#import "TYServer.h"
#import <SSKeychain.h>

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _validEmailSignal = [[RACObserve(self, account)
                              map:^id(NSString *text) {
                                  return @([NSString ty_validateEmail:text]);
                              }] distinctUntilChanged];
        
        _validPasswordSignal = [[RACObserve(self, password)
                                 map:^id(NSString *text) {
                                     return @([NSString ty_validatePassword:text]);
                                 }] distinctUntilChanged];
#if DEBUG
        _validPasswordSignal.name = @"validPasswordSignal";
        _validPasswordSignal = [_validPasswordSignal logAll];
        _validEmailSignal.name = @"validEmailSignal";
        _validEmailSignal = [_validEmailSignal logAll];
#endif
        _loginActiveSignal = [[_validEmailSignal combineLatestWith:_validPasswordSignal]
                              reduceEach:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                                  return @([usernameValid boolValue] && [passwordValid boolValue]);
                              }];
#if DEBUG
        _loginActiveSignal.name = @"loginActiveSignal";
        _loginActiveSignal = [_loginActiveSignal logAll];
#endif
        _executeLogin = [[RACCommand alloc] initWithEnabled:_loginActiveSignal signalBlock:^RACSignal *(id input) {
            TyLogDebug(@"executeLogin");
            return [[[self executeLoginSignal] setNameWithFormat:@"executeLoginSignal"] logAll];
        }];
        
        _loginCompletedSignal = [self.executeLogin.executionSignals flattenMap:^RACStream *(RACSignal *value) {
            return [[value materialize] filter:^BOOL(RACEvent *value) {
                return value.eventType == RACEventTypeCompleted;
            }];
        }];
        
    }
    return self;
}

- (RACSignal *)executeLoginSignal
{
    @weakify(self);
    RACSignal *executeLoginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSURLSessionDataTask *task = [self.sessionManager POST:@"login" parameters:@{TYServerKeyEmail: self.account, TYServerKeyPassword: self.password} progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *responseObject) {
            BOOL isError = [[responseObject objectForKey:TYServerKeyError] boolValue];
            if (isError) {
                NSString *message = [responseObject objectForKey:TYServerKeyMessage];
                NSError *error = [NSError errorWithDomain:message code:0 userInfo:nil];
                [subscriber sendError:error];
            } else {
                [SSKeychain setPassword:self.password forService:TYServiceName account:self.account];
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return executeLoginSignal;
}

@end
