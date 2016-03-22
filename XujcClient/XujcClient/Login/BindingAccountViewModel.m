//
//  BindingAccountViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "BindingAccountViewModel.h"
#import "XujcService.h"
#import "XujcUser.h"
#import "DynamicData.h"
#import "TYService.h"
#import "AppDelegate.h"

NSString * const kBindingRequestDomain = @"BindingRequestDomain";

NSString * const kXujcKeyAuthenticationFaildMessage = @"Xujc Key authentication failed";

NSString * const kApiKeyAuthenticationFaildMessage = @"Authentication failed";

@interface BindingAccountViewModel()

@end

@implementation BindingAccountViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _validStudentIdSignal = [[RACObserve(self, studentId)
                                  map:^id(NSString *text) {
                                      return @(![NSString isEmpty:text]);
                                  }] distinctUntilChanged];
        
        _validApiKeySuffixSignal = [[RACObserve(self, apiKeySuffix)
                                  map:^id(NSString *text) {
                                      return @(![NSString isEmpty:text]);
                                  }] distinctUntilChanged];
        
        _bindingActiveSignal = [[self.validStudentIdSignal combineLatestWith:self.validApiKeySuffixSignal]
                              reduceEach:^id(NSNumber *studentValid, NSNumber *apiKeyValid) {
                                  return @([studentValid boolValue] && [apiKeyValid boolValue]);
                              }];
        
        _executeBinding = [[RACCommand alloc] initWithEnabled:_bindingActiveSignal signalBlock:^RACSignal *(id input) {
            return [self executeBindingSignal];
        }];
    }
    return self;
}

- (RACSignal *)executeBindingSignal
{
    @weakify(self);
    RACSignal *executeBindingSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        __block NSURLSessionDataTask *subTask = nil;
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"me.php" parameters:@{XujcServiceKeyApiKey: self.xujcApiKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TyLogDebug(@"Success Response: %@", responseObject);
            XujcUser *user = [[XujcUser alloc] initWithJSONResopnse:responseObject];
            TyLogDebug(@"User Infomation: %@", [user description]);
            
            subTask = [self.sessionManager PUT:@"bindXujcAccount" parameters:@{TYServiceKeyAuthorization: DYNAMIC_DATA.apiKey, TYServiceKeyXujcKey: self.xujcApiKey} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                BOOL isError = [[responseObject objectForKey:TYServiceKeyError] boolValue];
                if (isError) {
                    NSString *message = [responseObject objectForKey:TYServiceKeyMessage];
                    NSError *error = [NSError errorWithDomain:kBindingRequestDomain code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(message, nil)}];
                    [subscriber sendError:error];
                } else {
                    [self p_saveXujcKey:self.xujcApiKey];
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
                if (statusCode == 401) {
                    [subscriber sendError:[NSError errorWithDomain:kBindingRequestDomain
                                                              code:0
                                                          userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(kApiKeyAuthenticationFaildMessage, nil)}
                                           ]];
                } else {
                    [subscriber sendError:error];
                }
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
            if (statusCode == 401) {
                [subscriber sendError:[NSError errorWithDomain:kBindingRequestDomain
                                                          code:0
                                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(kXujcKeyAuthenticationFaildMessage, nil)}
                                       ]];
            } else {
                [subscriber sendError:error];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [subTask cancel];
            [task cancel];
        }];
    }];
    return [[executeBindingSignal setNameWithFormat:@"executeBindingSignal"] logAll];
}

- (NSString *)xujcApiKey
{
    return [NSString stringWithFormat:@"%@-%@", _studentId, _apiKeySuffix];
}

- (void)p_saveXujcKey:(NSString *)xujcKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[xujcKey copy] forKey:kUserDefaultsKeyXujcKey];
    [userDefaults synchronize];
}

@end
