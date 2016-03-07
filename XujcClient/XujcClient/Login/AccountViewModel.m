//
//  AccountViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AccountViewModel.h"
#import "NSString+Validator.h"

@implementation AccountViewModel

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
        
    }
    return self;
}

@end
