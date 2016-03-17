//
//  OssService.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "OssService.h"
#import <OSSClient.h>
#import <OSSModel.h>
#import "TYServer.h"
#import "DynamicData.h"
#import "UIImage+Coding.h"

@implementation OssService

+ (OSSClient *)client
{
    static OSSClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
            NSURL * url = [NSURL URLWithString:@"changeAvatar" relativeToURL:[NSURL URLWithString:[AFHTTPSessionManager ty_serviceBaseURL]]];
            NSMutableURLRequest * mutableRequest = [NSMutableURLRequest requestWithURL:url];
            mutableRequest.HTTPMethod = @"POST";
            [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            mutableRequest.HTTPBody = [[[NSString alloc] initWithFormat:@"%@=%@", TYServerKeyAuthorization, DYNAMIC_DATA.apiKey] dataUsingEncoding:NSUTF8StringEncoding];
            
            OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
            NSURLSession * session = [NSURLSession sharedSession];
            
            NSURLSessionTask * sessionTask = [session dataTaskWithRequest:mutableRequest
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            if (error) {
                                                                [tcs setError:error];
                                                                return;
                                                            }
                                                            [tcs setResult:data];
                                                        }];
            [sessionTask resume];
            
            [tcs.task waitUntilFinished];
            
            if (tcs.task.error) {
                TyLogDebug(@"get token error: %@", tcs.task.error);
                return nil;
            } else {
                NSDictionary * responseObject = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                                options:kNilOptions
                                                                                  error:nil];
                
                NSString *accessKeyId = [responseObject objectForKey:TYServerKeyAccessKeyId];
                NSString *accessKeySecret = [responseObject objectForKey:TYServerKeyAccessKeySecret];
                NSString *expiration = [responseObject objectForKey:TYServerKeyExpiration];
                NSString *securityToken = [responseObject objectForKey:TYServerKeySecurityToken];
                
                OSSFederationToken * token = [[OSSFederationToken alloc] init];
                token.tAccessKey = accessKeyId;
                token.tSecretKey = accessKeySecret;
                token.tToken = securityToken;
                token.expirationTimeInGMTFormat = expiration;
                
                TyLogDebug(@"get token: %@", token);
                return token;
            }
        }];
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 3;
        conf.enableBackgroundTransmitService = YES; // 是否开启后台传输服务，目前，开启后，只对上传任务有效
        conf.timeoutIntervalForRequest = 15;
        conf.timeoutIntervalForResource = 24 * 60 * 60;
        sharedClient = [[OSSClient alloc] initWithEndpoint:@"oss-cn-hangzhou.aliyuncs.com" credentialProvider:credential clientConfiguration:conf];
    });
    return sharedClient;
}

+ (RACSignal *)updateAvatarSignalWithImage:(UIImage *)image
{
    RACSignal *updateAvatarSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        OSSPutObjectRequest * put = [[OSSPutObjectRequest alloc] init];
        put.bucketName = @"xujc-client";
        put.objectKey = @"avatars/test";
        put.uploadingData = [image imageData];
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            [subscriber sendNext:@(totalByteSent * 1.f / totalBytesExpectedToSend)];
        };
        OSSTask * putTask = [[OssService client] putObject:put];
        
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:task.error];
            }
            return nil;
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [put cancel];
        }];
    }];
    
    return [[updateAvatarSignal setNameWithFormat:@"OssService updateAvatarSignal"] logAll];
}

@end
