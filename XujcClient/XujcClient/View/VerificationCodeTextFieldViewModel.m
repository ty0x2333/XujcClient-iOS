//
//  VerificationCodeTextFieldViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/30.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "VerificationCodeTextFieldViewModel.h"
#import "NSString+Validator.h"
#import "TYService.h"

static NSString * const kVerificationCodeRequestDomain = @"VerificationCodeRequestDomain";

#if DEBUG
static NSInteger const kCountdownTime = 10;
#else
static NSInteger const kCountdownTime = 60;
#endif

@implementation VerificationCodeTextFieldViewModel

- (instancetype)init
{
    if (self = [super init]) {
        RACSignal *validPhoneSignal = [[RACObserve(self, phone)
                                         map:^id(NSString *text) {
                                             return @([NSString ty_validatePhone:text]);
                                         }] distinctUntilChanged];
        _executeGetVerificationCode = [[RACCommand alloc] initWithEnabled:validPhoneSignal signalBlock:^RACSignal *(id input) {
            return [self executeGetVerificationCodeSignal];
        }];
        
        _validVerificationCodeSignal = [[RACObserve(self, verificationCode)
                                                   map:^id(NSString *text) {
                                                       return @([NSString ty_validateVerificationCode:text]);
                                                   }] distinctUntilChanged];
    }
    return self;
}

- (RACSignal *)executeGetVerificationCodeSignal
{
    RACSignal *executeGetVerificationCodeSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self.sessionManager POST:@"sms" parameters:@{TYServiceKeyPhone: self.phone} progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *responseObject) {
            BOOL isError = [[responseObject objectForKey:TYServiceKeyError] boolValue];
            NSString *message = [responseObject objectForKey:TYServiceKeyMessage];
            if (isError) {
                NSError *error = [NSError errorWithDomain:kVerificationCodeRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
                [subscriber sendError:error];
            } else {
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
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return executeGetVerificationCodeSignal;
}

@end
