//
//  NSString+Safe.h
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Safe)

+ (BOOL)isEmpty:(NSString *)value;

+ (NSString *)safeString:(NSString *)value;

@end
