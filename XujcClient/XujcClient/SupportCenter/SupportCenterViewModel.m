//
//  SupportCenterViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/21.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SupportCenterViewModel.h"
#import "DynamicData.h"
#import <Instabug/Instabug.h>

@interface SupportCenterViewModel()

@property (strong, nonatomic) NSArray *texts;

@end

@implementation SupportCenterViewModel

- (instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        RACChannelTo(self, shakingReportStatus, @(NO)) = [userDefaults rac_channelTerminalForKey:kUserDefaultsKeyShakingReportStatus];
//        RACChannelTerminal *shakingReortStatusChannel = [userDefaults rac_channelTerminalForKey:kUserDefaultsKeyShakingReportStatus];
//        RACChannelTerminal *shakingReortStatusChannel = [[[[userDefaults rac_channelTerminalForKey:kUserDefaultsKeyShakingReportStatus] map:^id(NSNumber *value) {
//            return value ? value : @(NO);
//        }] setNameWithFormat:@"SupportCenterViewModel shakingReportStatusSignal"] logAll];
//        
//        [[RACObserve(self, shakingReportStatus) distinctUntilChanged] subscribeNext:^(id x) {
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            [userDefaults setBool:[x boolValue] forKey:kUserDefaultsKeyShakingReportStatus];
//        }];
        
        _texts = @[@[@"Feedback problems"], @[@"Capture feedback BUG by shaking"]];
    }
    return self;
}

- (NSInteger)numberOfSections
{
    return _texts.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[_texts objectAtIndex:section] count];
}

- (TableViewCellViewModel *)tableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellViewModel *viewModel = [[TableViewCellViewModel alloc] init];
    viewModel.localizedText = NSLocalizedString([(NSArray *)[_texts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row], nil);
    viewModel.selectionStyle = (indexPath.section == 1 && indexPath.row == 0) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;
    return viewModel;
}

@end
