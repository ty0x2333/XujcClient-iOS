//
//  ScheduleViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScheduleViewModel.h"
#import "XujcServer.h"
#import "DynamicData.h"
#import "XujcTerm.h"

@interface ScheduleViewModel()

@property (strong, nonatomic) XujcTerm *selectedTerm;

@end

@implementation ScheduleViewModel

- (RACSignal *)fetchTermsSignal
{
    @weakify(self);
    RACSignal *fetchTermsSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"kb.php" parameters:@{XujcServerKeyApiKey: DYNAMIC_DATA.xujcKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
            NSArray *termIds = [responseObject allKeys];
            NSMutableArray *termArray = [NSMutableArray arrayWithCapacity:termIds.count];
            for (id key in termIds) {
                XujcTerm *term = [[XujcTerm alloc] init];
                term.termId = key;
                term.displayName = responseObject[key];
                [termArray addObject:term];
            }
            [self p_saveTerms:termArray];
            
            self.selectedTerm = [DYNAMIC_DATA.terms lastObject];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [[fetchTermsSignal setNameWithFormat:@"fetchTermsSignal"] logAll];
}

#pragma mark - Helper
- (void)p_saveTerms:(NSArray *)terms
{
    NSMutableArray *termDataArray = [NSMutableArray arrayWithCapacity:terms.count];
    for (XujcTerm *term in terms) {
        [termDataArray addObject:[term data]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:termDataArray forKey:kUserDefaultsKeyXujcTerms];
}

@end
