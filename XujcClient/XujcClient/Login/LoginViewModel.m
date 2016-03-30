//
//  LoginViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/4.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LoginViewModel.h"
#import "NSString+Validator.h"
#import "TYService.h"
#import <SSKeychain.h>
#import "UserModel.h"
#import "DynamicData.h"

NSString * const kLoginRequestDomain = @"LoginRequestDomain";

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _loginActiveSignal = [[self.validPhoneSignal combineLatestWith:self.validPasswordSignal]
                              reduceEach:^id(NSNumber *phoneValid, NSNumber *passwordValid) {
                                  return @([phoneValid boolValue] && [passwordValid boolValue]);
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
        NSURLSessionDataTask *task = [self.sessionManager POST:@"login" parameters:@{TYServiceKeyPhone: self.account, TYServiceKeyPassword: self.password} progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *responseObject) {
            BOOL isError = [[responseObject objectForKey:TYServiceKeyError] boolValue];
            
            if (isError) {
                NSString *message = [responseObject objectForKey:TYServiceKeyMessage];
                NSError *error = [NSError errorWithDomain:kLoginRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
                [subscriber sendError:error];
            } else {
                [SSKeychain setPassword:self.password forService:TYServiceName account:self.account];
                UserModel *user = [[UserModel alloc] initWithJSONResopnse:responseObject];
                DYNAMIC_DATA.user = user;
                [DYNAMIC_DATA flush];
                TyLogDebug(@"%@", user);
                
                NSString *apiKey = [responseObject objectForKey:TYServiceKeyAPIKey];
                [self p_saveApiKey:apiKey];
                NSString *xujcKey = [responseObject objectForKey:TYServiceKeyXujcKey];
                [self p_saveXujcKey:xujcKey];
                
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

- (void)p_saveApiKey:(NSString *)apiKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[apiKey copy] forKey:kUserDefaultsKeyApiKey];
    [userDefaults synchronize];
}

- (void)p_saveXujcKey:(NSString *)xujcKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString safeString:xujcKey] forKey:kUserDefaultsKeyXujcKey];
    [userDefaults synchronize];
}

- (NSString *)currentAccountPhone
{
    return DYNAMIC_DATA.user.phone;
}

- (NSString *)currentAccountPassword
{
    return [SSKeychain passwordForService:TYServiceName account:[self currentAccountPhone]];
}

@end
