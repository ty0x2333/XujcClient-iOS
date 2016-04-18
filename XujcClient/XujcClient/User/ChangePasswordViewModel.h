//
//  ChangePasswordViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "VerificationCodeTextFieldViewModel.h"

@interface ChangePasswordViewModel : RequestViewModel

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;

@property (strong, nonatomic) RACSignal *changePasswordActiveSignal;
@property (strong, nonatomic) RACCommand *executeChangePassword;

@property (nonatomic, readonly, strong) VerificationCodeTextFieldViewModel *verificationCodeTextFieldViewModel;

@end
