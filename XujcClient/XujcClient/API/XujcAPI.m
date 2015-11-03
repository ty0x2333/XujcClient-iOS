/**
 * @file XujcAPI.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/30
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "XujcAPI.h"
#import <AFHTTPRequestOperationManager.h>

#define XUJCAPI_PREFIX @"http://jw.xujc.com/api/"

#pragma mark - URL Maker

#define XUJCAPI_URL_MAKER(sign) [NSString stringWithFormat:@"%@%@", XUJCAPI_PREFIX, sign]

#pragma mark 用户信息

#define XUJCAPI_USER_INFOMATION XUJCAPI_URL_MAKER(@"me.php")
#define XUJCAPI_TERMS XUJCAPI_URL_MAKER(@"kb.php")
#define XUJCAPI_CLASS_SCHEDULE XUJCAPI_URL_MAKER(@"kb.php")

#pragma mark - Request Keys

static NSString* const kRequestKeyAPIKey = @"apikey";
static NSString* const kRequestKeyTermId = @"tm_id";

@implementation XujcAPI

+ (void)userInfomation:(NSString *)APIKey
          successBlock:(ResponseSuccessBlock)success
          failureBlock:(ResponseFailureBlock)failure
{
    [[XujcAPI XujcManager] GET:XUJCAPI_USER_INFOMATION
      parameters:@{kRequestKeyAPIKey: APIKey}
          success:success
          failure:failure
     ];
}

+ (void)terms:(NSString *)APIKey
 successBlock:(ResponseSuccessBlock)success
 failureBlock:(ResponseFailureBlock)failure
{
    [[XujcAPI XujcManager] GET:XUJCAPI_TERMS
      parameters:@{kRequestKeyAPIKey: APIKey}
         success:success
         failure:failure
     ];
}

+ (void)classSchedule:(NSString *)APIKey
               termId:(NSString *)termId
         successBlock:(ResponseSuccessBlock)success
         failureBlock:(ResponseFailureBlock)failure
{
    [[XujcAPI XujcManager] GET:XUJCAPI_CLASS_SCHEDULE
      parameters:@{kRequestKeyAPIKey: APIKey, kRequestKeyTermId:termId}
         success:success
         failure:failure
     ];
}

#pragma mark - Helper

+ (AFHTTPRequestOperationManager *)XujcManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.stringEncoding = encoding;
    return manager;
}

@end
