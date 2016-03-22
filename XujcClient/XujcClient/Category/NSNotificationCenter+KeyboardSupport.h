//
//  NSNotificationCenter+KeyboardSupport.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/22.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (KeyboardSupport)

- (RACSignal *)ty_keyboardWillShowSignal;

- (RACSignal *)ty_keyboardWillHideSignal;

@end
