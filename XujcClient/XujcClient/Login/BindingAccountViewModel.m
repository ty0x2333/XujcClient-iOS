//
//  BindingAccountViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "BindingAccountViewModel.h"
#import "XujcService.h"
#import "XujcUserModel.h"
#import "DynamicData.h"
#import "TYService.h"
#import "AppDelegate.h"

@interface BindingAccountViewModel()

@end

@implementation BindingAccountViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _validStudentIdSignal = [[RACObserve(self, studentId)
                                  map:^id(NSString *text) {
                                      return @(![NSString isEmpty:text]);
                                  }] distinctUntilChanged];
        
        _validApiKeySuffixSignal = [[RACObserve(self, apiKeySuffix)
                                  map:^id(NSString *text) {
                                      return @(![NSString isEmpty:text]);
                                  }] distinctUntilChanged];
        
        _bindingActiveSignal = [[self.validStudentIdSignal combineLatestWith:self.validApiKeySuffixSignal]
                              reduceEach:^id(NSNumber *studentValid, NSNumber *apiKeyValid) {
                                  return @([studentValid boolValue] && [apiKeyValid boolValue]);
                              }];
        
        _executeBinding = [[RACCommand alloc] initWithEnabled:_bindingActiveSignal signalBlock:^RACSignal *(id input) {
            return [self executeBindingSignal];
        }];
    }
    return self;
}

- (RACSignal *)executeBindingSignal
{
    RACSignal *userInfoSignal = [self.xujcSessionManager requestUserInformationSignalWithXujcKey:[self xujcApiKey]];
    
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [userInfoSignal subscribeNext:^(id x) {} error:^(NSError *error) {
            [subscriber sendError:error];
        } completed:^{
            @strongify(self);
            RACSignal *bindingSignal = [self.sessionManager requestBindingXujcAccountSignalWithXujcKey:[self xujcApiKey]];
            
            [bindingSignal subscribeNext:^(NSString *xujcKey) {
                DYNAMIC_DATA.xujcKey = xujcKey;
                [subscriber sendNext:nil];
            } error:^(NSError *error) {
                [subscriber sendError:error];
            } completed:^{
                [subscriber sendCompleted];
            }];
        }];
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    return signal;
}

- (NSString *)xujcApiKey
{
    return [NSString stringWithFormat:@"%@-%@", _studentId, _apiKeySuffix];
}

@end
