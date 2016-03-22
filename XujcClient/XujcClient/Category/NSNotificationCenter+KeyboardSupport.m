//
//  NSNotificationCenter+KeyboardSupport.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/22.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "NSNotificationCenter+KeyboardSupport.h"

@implementation NSNotificationCenter (KeyboardSupport)

- (RACSignal *)ty_keyboardWillShowSignal
{
    return [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil];
}

- (RACSignal *)ty_keyboardWillHideSignal
{
    return [[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil];
}

@end
