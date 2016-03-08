//
//  BindingAccountViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "BindingAccountViewModel.h"
#import "XujcServer.h"
#import "XujcUser.h"

@interface BindingAccountViewModel()

@property (strong, nonatomic) AFHTTPSessionManager *xujcSessionManager;

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

- (AFHTTPSessionManager *)xujcSessionManager
{
    if (!_xujcSessionManager) {
        _xujcSessionManager = [AFHTTPSessionManager xujc_manager];
    }
    return _xujcSessionManager;
}

- (void)dealloc
{
    [self.xujcSessionManager invalidateSessionCancelingTasks:YES];
}

- (RACSignal *)executeBindingSignal
{
    @weakify(self);
    RACSignal *executeBindingSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"me.php" parameters:@{XujcServerKeyApiKey: self.apiKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            TyLogDebug(@"Success Response: %@", responseObject);
            XujcUser *user = [[XujcUser alloc] initWithJSONResopnse:responseObject];
            TyLogDebug(@"User Infomation: %@", [user description]);
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [[executeBindingSignal setNameWithFormat:@"executeBindingSignal"] logAll];
}

- (NSString *)apiKey
{
    return [NSString stringWithFormat:@"%@-%@", _studentId, _apiKeySuffix];
}

@end
