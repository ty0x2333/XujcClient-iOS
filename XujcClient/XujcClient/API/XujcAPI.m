/**
 * @file XujcAPI.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/30
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcAPI.h"

static const NSString* kXujcAPIBaseURL = @"http://jw.xujc.com/api/";

#pragma mark - URL Maker

#pragma mark 用户信息

#define XUJCAPI_USER_INFOMATION @"me.php"
#define XUJCAPI_TERMS @"kb.php"
#define XUJCAPI_CLASS_SCHEDULE @"kb.php"
#define XUJCAPI_CLASS_SCORE @"score.php"

#pragma mark - Request Keys

static NSString* const kRequestKeyAPIKey = @"apikey";
static NSString* const kRequestKeySemesterId = @"tm_id";

@implementation XujcAPI

+ (void)userInfomation:(nonnull NSString *)APIKey
          successBlock:(nullable ResponseSuccessBlock)success
          failureBlock:(nullable ResponseFailureBlock)failure
{
    [[XujcAPI XujcManager] GET:XUJCAPI_USER_INFOMATION
                    parameters:@{kRequestKeyAPIKey: APIKey}
                      progress:nil
                       success:success
                       failure:failure
     ];
}

+ (void)semesters:(nonnull NSString *)APIKey
 successBlock:(nullable ResponseSuccessBlock)success
 failureBlock:(nullable ResponseFailureBlock)failure
{
    [[XujcAPI XujcManager] GET:XUJCAPI_TERMS
                    parameters:@{kRequestKeyAPIKey: APIKey}
                      progress:nil
                       success:success
                       failure:failure
     ];
}

+ (void)classSchedule:(nonnull NSString *)APIKey
               semesterId:(nonnull NSString *)semesterId
         successBlock:(nullable ResponseSuccessBlock)success
         failureBlock:(nullable ResponseFailureBlock)failure
{
    [[XujcAPI XujcManager] GET:XUJCAPI_CLASS_SCHEDULE
                    parameters:@{kRequestKeyAPIKey: APIKey, kRequestKeySemesterId:semesterId}
                      progress:nil
                       success:success
                       failure:failure
     ];
}

+ (void)scores:(nonnull NSString *)APIKey
        semesterId:(nonnull NSString *)semesterId
  successBlock:(nullable ResponseSuccessBlock)success
  failureBlock:(nullable ResponseFailureBlock)failure
{
    [[XujcAPI XujcManager] GET:XUJCAPI_CLASS_SCORE
                    parameters:@{kRequestKeyAPIKey: APIKey, kRequestKeySemesterId:semesterId}
                      progress:nil
                       success:success
                       failure:failure
     ];
}

#pragma mark - Helper

+ (AFHTTPSessionManager *)XujcManager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[kXujcAPIBaseURL copy]]];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    manager.requestSerializer.stringEncoding = encoding;
    return manager;
}

@end
