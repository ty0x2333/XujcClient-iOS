//
//  VerificationCodeTextFieldViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/30.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "VerificationCodeTextFieldViewModel.h"
#import "NSString+Validator.h"

static NSString * const kVerificationCodeRequestDomain = @"VerificationCodeRequestDomain";

#if DEBUG
static NSInteger const kCountdownTime = 10;
#else
static NSInteger const kCountdownTime = 60;
#endif

@interface VerificationCodeTextFieldViewModel()

@property (nonatomic, assign) VerificationCodeType verificationCodeType;

@end

@implementation VerificationCodeTextFieldViewModel

- (instancetype)initWithType:(VerificationCodeType)verificationCodeType
{
    if (self = [super init]) {
        _verificationCodeType = verificationCodeType;
        
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
    __block NSInteger number = kCountdownTime;
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [[self.sessionManager requestGetVerificationCodeSignalWithPhone:self.phone withType:self.verificationCodeType] subscribeNext:^(id x) {
            RACSignal *timerSignal = [[[RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]] take:number] map:^id(id x) {
                return @(--number);
            }];
            
            [subscriber sendNext:@(number)];
            [timerSignal subscribeNext:^(NSNumber *value) {
                [subscriber sendNext:value];
            } completed:^{
                [subscriber sendCompleted];
            }];
        } error:^(NSError *error) {
            [subscriber sendError:error];
        }];
    }];
    return signal;
}

@end
