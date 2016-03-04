//
//  LoginViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/4.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface LoginViewModel : NSObject

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) RACCommand *executeLogin;

@property (strong, nonatomic) RACSignal *validEmailSignal;
@property (strong, nonatomic) RACSignal *validPasswordSignal;

@property (strong, nonatomic) RACSignal *loginActiveSignal;

@end
