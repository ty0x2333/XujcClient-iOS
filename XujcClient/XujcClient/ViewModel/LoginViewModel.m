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
#import "UserModel.h"
#import "DynamicData.h"

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _loginActiveSignal = [[self.validEmailSignal combineLatestWith:self.validPasswordSignal]
                              reduceEach:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                                  return @([usernameValid boolValue] && [passwordValid boolValue]);
                              }];
        
        _executeLogin = [[RACCommand alloc] initWithEnabled:_loginActiveSignal signalBlock:^RACSignal *(id input) {
            return [self executeLoginSignal];
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
                UserModel *user = [[UserModel alloc] initWithJSONResopnse:responseObject];
                DYNAMIC_DATA.user = user;
                [DYNAMIC_DATA flush];
                TyLogDebug(@"%@", user);
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
    return [[executeLoginSignal setNameWithFormat:@"executeLoginSignal"] logAll];
}

- (NSString *)currentAccount
{
    return DYNAMIC_DATA.user.email;
}

- (NSString *)currentAccountPassword
{
    return [SSKeychain passwordForService:TYServiceName account:[self currentAccount]];
}

- (BindingAccountViewModel *)bindingAccountViewModel
{
    return [[BindingAccountViewModel alloc] init];
}

@end
