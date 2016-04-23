//
//  SettingsViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SettingsViewModel.h"
#import "CacheUtils.h"
#import "UserModel.h"
#import "DynamicData.h"

@interface SettingsViewModel()

@property (strong, nonatomic) NSArray<NSString *> *texts;
@property (strong, nonatomic) NSArray<RACCommand *> *executeCommands;

@end

@implementation SettingsViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _texts = @[@[@"Clean cache"], @[@"Logout"]];
        
        _executeLoginout = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [self executeLoginoutSignal];
        }];
        
        _executeCleanCache = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [[CacheUtils instance] cleanCache];
                [[NSURLCache sharedURLCache] removeAllCachedResponses];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return [RACDisposable disposableWithBlock:^{}];
            }];
        }];
        
        _executeCommands = @[@[_executeCleanCache], @[_executeLoginout]];
    }
    return self;
}

- (RACSignal *)executeLoginoutSignal
{
    RACSignal *executeLoginoutSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [DYNAMIC_DATA cleanAllIdentityInformation];
        [[CacheUtils instance] cleanCache];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{}];
    }];
    return [[executeLoginoutSignal setNameWithFormat:@"SettingsViewModel executeLoginoutSignal"] logAll];
}

- (RACCommand *)executeCommandForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [(NSArray *)[_executeCommands objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSString *)localizedTextForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [(NSArray *)[_texts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return NSLocalizedString(text, nil);
}

- (NSInteger)numberOfSections
{
    return _texts.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[_texts objectAtIndex:section] count];
}

@end
