//
//  NSError+Valid.h
//  XujcClient
//
//  Created by 田奕焰 on 16/5/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TYValidErrorDomain;

@interface NSError (Valid)

+ (NSError *)ty_validPhoneError;

+ (NSError *)ty_validPasswordError;

@end
