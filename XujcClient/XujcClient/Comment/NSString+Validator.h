//
//  NSString+Validator.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validator)

+ (BOOL)ty_validatePhone:(NSString *)value;

+ (BOOL)ty_validateEmail:(NSString *)value;

+ (BOOL)ty_validateUsername:(NSString *)value;

+ (BOOL)ty_validatePassword:(NSString *)value;

@end
