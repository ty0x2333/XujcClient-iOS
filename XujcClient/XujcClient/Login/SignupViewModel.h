//
//  SignupViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AccountViewModel.h"

@interface SignupViewModel : AccountViewModel

@property (copy, nonatomic) NSString *nickname;

@property (copy, nonatomic) NSString *verificationCode;

@property (strong, nonatomic) RACSignal *timerSignal;

@property (strong, nonatomic) RACCommand *executeSignup;

@property (strong, nonatomic) RACCommand *executeGetVerificationCode;

@property (strong, nonatomic) RACSignal *signupActiveSignal;

@property (strong, nonatomic) RACSignal *validNicknameSignal;

@end
