//
//  SignupViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AccountViewModel.h"
@class ServiceProtocolViewModel;
@class VerificationCodeTextFieldViewModel;

@interface SignupViewModel : AccountViewModel

@property (copy, nonatomic) NSString *nickname;

@property (strong, nonatomic) RACCommand *executeSignup;

@property (strong, nonatomic) RACSignal *signupActiveSignal;

@property (strong, nonatomic) RACSignal *validNicknameSignal;

@property (readonly, strong, nonatomic) VerificationCodeTextFieldViewModel *verificationCodeTextFieldViewModel;

- (ServiceProtocolViewModel *)serviceProtocolViewModel;

@end
