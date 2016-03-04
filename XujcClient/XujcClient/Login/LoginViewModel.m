//
//  LoginViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/4.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _validLoginSignal = [[RACObserve(self, account)
                              map:^id(NSString *text) {
                                  return @(text.length > 0);
                              }] distinctUntilChanged];
        
        [_validLoginSignal subscribeNext:^(id x) {
            NSLog(@"account text is valid %@", x);
        }];
        
        _executeLogin = [[RACCommand alloc] initWithEnabled:_validLoginSignal signalBlock:^RACSignal *(id input) {
            TyLogDebug(@"executeLogin");
            return [self executeLoginSignal];
        }];
    }
    return self;
}

- (RACSignal *)executeLoginSignal
{
    return [[[[RACSignal empty] logAll] delay:2.0] logAll];
}

@end
