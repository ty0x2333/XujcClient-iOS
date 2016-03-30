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

static NSString * const kSignupRequestDomain = @"SignupRequestDomain";

static NSInteger const kCountdownTime = 10;

@interface SignupViewModel()

@property (assign, nonatomic) NSInteger countdown;

@end

@implementation SignupViewModel

- (instancetype)init
{
    if (self = [super init]) {
        RACSignal *validVerificationCodeSignal = [[RACObserve(self, verificationCode)
                                                   map:^id(NSString *text) {
                                                       return @([NSString ty_validateVerificationCode:text]);
                                                   }] distinctUntilChanged];
        
        @weakify(self);
        _timerSignal = [[[[[RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]] take:kCountdownTime] startWith:@(1)] map:^id(id x) {
            @strongify(self);
            self.countdown--;
            return @(self.countdown == 0);
        }] takeUntil:self.rac_willDeallocSignal];
        
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
        
        _executeGetVerificationCode = [[RACCommand alloc] initWithEnabled:self.validPhoneSignal signalBlock:^RACSignal *(id input) {
//            self.countdown = kCountdownTime;
            return [self executeGetVerificationCodeSignal];
        }];
    }
    return self;
}

- (RACSignal *)executeSignupSignal
{
    @weakify(self);
    RACSignal *executeSignupSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self.sessionManager POST:@"register" parameters:@{TYServiceKeyNickname: self.nickname, TYServiceKeyPhone: self.account, TYServiceKeyPassword: self.password} progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *responseObject) {
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

- (RACSignal *)executeGetVerificationCodeSignal
{
    RACSignal *executeGetVerificationCodeSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSInteger number = kCountdownTime;
        RACSignal *timerSignal = [[[RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]] take:number] map:^id(id x) {
            return @(--number);
        }];
        
        [subscriber sendNext:@(number)];
        [timerSignal subscribeNext:^(NSNumber *value) {
            [subscriber sendNext:value];
        } completed:^{
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            //            [task cancel];
        }];
    }];
    return executeGetVerificationCodeSignal;
}

@end
