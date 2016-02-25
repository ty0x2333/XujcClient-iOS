/**
 * @file XujcAPI.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/30
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void (^ResponseSuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void (^ResponseFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

@interface XujcAPI : NSObject

+ (void)userInfomation:(nonnull NSString *)APIKey
          successBlock:(nullable ResponseSuccessBlock)success
          failureBlock:(nullable ResponseFailureBlock)failure;

+ (void)terms:(nonnull NSString *)APIKey
 successBlock:(nullable ResponseSuccessBlock)success
 failureBlock:(nullable ResponseFailureBlock)failure;

+ (void)classSchedule:(nonnull NSString *)APIKey
               termId:(nonnull NSString *)termId
         successBlock:(nullable ResponseSuccessBlock)success
         failureBlock:(nullable ResponseFailureBlock)failure;

@end
