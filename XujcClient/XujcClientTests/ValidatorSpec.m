//
//  ValidatorSpec.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/14.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Kiwi.h>
#import "NSString+Validator.h"

SPEC_BEGIN(ValidatorSpec)

describe(@"Validator", ^{
    
    // Phone
    NSDictionary *validatePhones = @{
                                     @"18000000001" : @(YES),
                                     
                                     @"180000000012" : @(NO),
                                     @"1800000000" : @(NO),
                                     };
    
    [validatePhones enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull phone, id  _Nonnull result, BOOL * _Nonnull stop) {
        context([NSString stringWithFormat:@"when phone is %@", phone], ^{
            it([NSString stringWithFormat:@"should return %@", [result boolValue] ? @"YES" : @"NO"], ^{
                [[theValue([NSString ty_validatePhone:phone]) should] equal:theValue([result boolValue])];
            });
        });
    }];
    
    // Email
    NSDictionary *validateEmails = @{
                                     @"1@email.com" : @(YES),
                                     @"1@email.com.net" : @(YES),
                                     
                                     @"1email.com" : @(NO),
                                     @"1@email" : @(NO),
                                     };
    [validateEmails enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull email, id  _Nonnull result, BOOL * _Nonnull stop) {
        context([NSString stringWithFormat:@"when email is %@", email], ^{
            it([NSString stringWithFormat:@"should return %@", [result boolValue] ? @"YES" : @"NO"], ^{
                [[theValue([NSString ty_validateEmail:email]) should] equal:theValue([result boolValue])];
            });
        });
    }];
    
    // User Name
    NSDictionary *validateUsernames = @{
                                        @"luckytianyiyan" : @(YES),
                                        @"11111" : @(YES),

                                        @"" : @(NO),
                                        @"a" : @(NO),
                                        @"1@email.com" : @(NO),
                                        @"abcdefghijklmnopqrstu" : @(NO),
                                        };
    [validateUsernames enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull username, id  _Nonnull result, BOOL * _Nonnull stop) {
        context([NSString stringWithFormat:@"when username is %@", username], ^{
            it([NSString stringWithFormat:@"should return %@", [result boolValue] ? @"YES" : @"NO"], ^{
                [[theValue([NSString ty_validateUsername:username]) should] equal:theValue([result boolValue])];
            });
        });
    }];
    
    // Password
    NSDictionary *validatePasswords = @{
                                         @"123456" : @(YES),
                                         @"1abcde" : @(YES),
                                         
                                         @"" : @(NO),
                                         @"12345" : @(NO),
                                         @"1 2_34" : @(NO),
                                         @"123!5@" : @(NO),
                                         };
    [validatePasswords enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull password, id  _Nonnull result, BOOL * _Nonnull stop) {
        context([NSString stringWithFormat:@"when password code is %@", password], ^{
            it([NSString stringWithFormat:@"should return %@", [result boolValue] ? @"YES" : @"NO"], ^{
                [[theValue([NSString ty_validatePassword:password]) should] equal:theValue([result boolValue])];
            });
        });
    }];
    
    // Vertification Code
    NSDictionary *validateVertificationCodes = @{
                                                @"123456" : @(YES),

                                                @"" : @(NO),
                                                @"12345" : @(NO),
                                                @"abcdef" : @(NO),
                                                @"1abcde" : @(NO),
                                                };
    [validateVertificationCodes enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull code, id  _Nonnull result, BOOL * _Nonnull stop) {
        context([NSString stringWithFormat:@"when vertification code is %@", code], ^{
            it([NSString stringWithFormat:@"should return %@", [result boolValue] ? @"YES" : @"NO"], ^{
                [[theValue([NSString ty_validateVerificationCode:code]) should] equal:theValue([result boolValue])];
            });
        });
    }];
});

SPEC_END