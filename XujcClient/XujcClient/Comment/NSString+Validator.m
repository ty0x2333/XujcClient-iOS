//
//  NSString+Validator.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSString+Validator.h"

static NSString* const kPhoneRegex = @"^1[0-9]{10}$";
static NSString* const kVerificationCodeRegex = @"^[0-9]{6}$";
static NSString* const kPasswordRegex = @"^[A-Za-z0-9]{6,30}$";
//static NSString* const kNumberRegex = @"^\\d+$";
static NSString* const kNicknameRegex = @"^\\w{2,20}$";
static NSString* const kEmailRegex = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";

@implementation NSString (Validator)

+ (BOOL)ty_validateEmail:(NSString *)value
{
    return [NSString ty_p_isValidate:value regex:kEmailRegex];
}

+ (BOOL)ty_validatePhone:(NSString *)value
{
    return [NSString ty_p_isValidate:value regex:kPhoneRegex];
}

+ (BOOL)ty_validateVerificationCode:(NSString *)value
{
    return [NSString ty_p_isValidate:value regex:kVerificationCodeRegex];
}

+ (BOOL)ty_validateUsername:(NSString *)value
{
    return [NSString ty_p_isValidate:value regex:kNicknameRegex];
}

+ (BOOL)ty_validatePassword:(NSString *)value
{
    return [NSString ty_p_isValidate:value regex:kPasswordRegex];
}

#pragma Helper

+ (BOOL)ty_p_isValidate:(NSString *)value regex:(NSString *)regex
{
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:value];
}

@end
