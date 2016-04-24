//
//  AFHTTPSessionManager+TYService.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "AFHTTPSessionManager+TYService.h"
#import "TYServiceKeys.h"
#import "DynamicData.h"

NSString * const kTYServiceRequestDomain = @"TYServiceRequestDomain";

// Local
//static NSString* const kTYServiceHost = @"http://192.168.1.101:8080/";
// Online
static NSString* const kTYServiceHost = @"http://xujcservice.tianyiyan.com/";

static NSString* const kTYServiceAPIVersion = @"v1/";

@implementation AFHTTPSessionManager (TYService)

+ (instancetype)ty_manager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self ty_serviceBaseURL]]];
    return manager;
}

+ (NSString *)ty_serviceBaseURL
{
    return [NSString stringWithFormat:@"%@%@", kTYServiceHost, kTYServiceAPIVersion];
}

+ (NSString *)ty_shareURL
{
    return [NSString stringWithFormat:@"%@/share", [self ty_serviceBaseURL]];
}

- (RACSignal *)requestBindingXujcAccountSignalWithXujcKey:(NSString *)xujcKey
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self PUT:@"xujc_account" parameters:@{TYServiceKeyAuthorization: DYNAMIC_DATA.apiKey, TYServiceKeyXujcKey: xujcKey} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            BOOL isError = [[responseObject objectForKey:TYServiceKeyError] boolValue];
            if (isError) {
                NSString *message = [responseObject objectForKey:TYServiceKeyMessage];
                NSError *error = [NSError errorWithDomain:kTYServiceRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:xujcKey];
                [subscriber sendCompleted];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([[self class] p_cleanApiKeyIfNeedWithTask:task]) {
                [subscriber sendError:[[self class] p_ty_authenticationError]];
            } else {
                [subscriber sendError:error];
            }
            
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    signal.name = [NSString stringWithFormat:@"requestBindingXujcAccountSignalWithXujcKey: %@", xujcKey];
    return [[signal replayLazily] ty_logAll];
}

#pragma mark - Helper

+ (BOOL)p_cleanApiKeyIfNeedWithTask:(NSURLSessionDataTask *)task
{
    if (![[self class] p_isAuthenticationError:task]) {
        return NO;
    }
    [DYNAMIC_DATA cleanApiKey];
    return YES;
}

+ (BOOL)p_isAuthenticationError:(NSURLSessionDataTask *)task
{
    if (![task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return NO;
    }
    return ((NSHTTPURLResponse *)task.response).statusCode == 401;
}

+ (NSError *)p_ty_authenticationError
{
    return [NSError errorWithDomain:kTYServiceRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Authentication failed", nil)}];
}

@end
