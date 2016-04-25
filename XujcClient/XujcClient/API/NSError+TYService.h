//
//  NSError+TYService.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const TYServiceRequestDomain;

@interface NSError (TYService)

+ (NSError *)ty_authenticationError;

@end
