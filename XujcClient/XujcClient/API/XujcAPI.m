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


#pragma mark - Request Keys

static NSString* const kRequestKeyAPIKey = @"apikey";

@implementation XujcAPI

+ (void)userInfomation:(NSString *)APIKey
          successBlock:(ResponseSuccessBlock)success
          failureBlock:(ResponseFailureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:XUJCAPI_USER_INFOMATION
      parameters:@{kRequestKeyAPIKey: APIKey}
          success:success
          failure:failure
     ];
}

@end
