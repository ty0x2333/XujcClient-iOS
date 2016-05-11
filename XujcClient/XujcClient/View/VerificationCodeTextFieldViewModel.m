//
//  VerificationCodeTextFieldViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/30.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "VerificationCodeTextFieldViewModel.h"
#import "NSString+Validator.h"
#import "NSError+Valid.h"

static NSString * const kVerificationCodeRequestDomain = @"VerificationCodeRequestDomain";

#if DEBUG
static NSInteger const kCountdownTime = 10;
#else
static NSInteger const kCountdownTime = 60;
#endif

@interface VerificationCodeTextFieldViewModel()

@property (nonatomic, assign) VerificationCodeType verificationCodeType;

@property (nonatomic, assign) BOOL isValidPhone;

@end

@implementation VerificationCodeTextFieldViewModel

- (instancetype)initWithType:(VerificationCodeType)verificationCodeType
{
    if (self = [super init]) {
        _verificationCodeType = verificationCodeType;
        
        RACSignal *getVerificationCodeActiveSignal = [RACObserve(self, phone) map:^id(NSString *phone) {
            return @(![NSString isEmpty:phone]);
        }];
        
        @weakify(self);
        _executeGetVerificationCode = [[RACCommand alloc] initWithEnabled:getVerificationCodeActiveSignal signalBlock:^RACSignal *(id input) {
            @strongify(self);
            if (![NSString ty_validatePhone:self.phone]) {
                return [RACSignal error:[NSError ty_validPhoneError]];
            }
            return [self executeGetVerificationCodeSignal];
        }];
        
        _validVerificationCodeSignal = [[RACObserve(self, verificationCode)
                                                   map:^id(NSString *text) {
                                                       return @([NSString ty_validateVerificationCode:text]);
                                                   }] distinctUntilChanged];
        
        RAC(self, isValidVerificationCode) = _validVerificationCodeSignal;
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
