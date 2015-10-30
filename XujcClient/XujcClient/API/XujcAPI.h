/**
 * @file XujcAPI.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/30
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperation.h>

typedef void (^ResponseSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^ResponseFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface XujcAPI : NSObject

+ (void)userInfomation:(NSString *)APIKey
          successBlock:(ResponseSuccessBlock)success
          failureBlock:(ResponseFailureBlock)failure;

@end
