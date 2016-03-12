//
//  TermSelectorViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TermSelectorViewModel.h"
#import "CacheUtils.h"
#import "XujcServer.h"
#import "DynamicData.h"

@interface TermSelectorViewModel()

@property (strong, nonatomic) NSArray<XujcTerm *> *terms;

@end

@implementation TermSelectorViewModel

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
            
            [[CacheUtils instance] cacheTerms:termArray];
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"termId" ascending:NO];
            self.terms = [termArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            self.selectedTerm = [self.terms firstObject];
            
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

- (NSInteger)termCount
{
    return _terms.count;
}

- (TermTableViewCellViewModel *)termTableViewCellViewModelAtIndex:(NSInteger)index
{
    TermTableViewCellViewModel *viewModel = [[TermTableViewCellViewModel alloc] init];
    viewModel.xujcTermModel = [_terms objectAtIndex:index];
    return viewModel;
}

@end
