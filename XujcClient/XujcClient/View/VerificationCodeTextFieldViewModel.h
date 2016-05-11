//
//  VerificationCodeTextFieldViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/30.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "TYService.h"

@interface VerificationCodeTextFieldViewModel : RequestViewModel

- (instancetype)initWithType:(VerificationCodeType)verificationCodeType;

@property (copy, nonatomic) NSString *phone;

@property (copy, nonatomic) NSString *verificationCode;

@property (nonatomic, assign, readonly) BOOL isValidVerificationCode;

@property (readonly, copy, nonatomic) RACSignal *validVerificationCodeSignal;

@property (readonly, strong, nonatomic) RACCommand *executeGetVerificationCode;

@end
