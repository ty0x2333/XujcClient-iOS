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
        RACChannelTo(self, shakingReportStatus, @(NO)) = [userDefaults ty_channelTerminalForShakingReportStatus];
        
        _texts = @[@[@"Feedback problems"], @[@"Capture feedback BUG by shaking"], @[@"Service Protocol"]];
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

- (NSString *)versionDescription
{
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    return [NSString stringWithFormat:@"XujcClient iOS Version %@ (%@)", info[@"CFBundleShortVersionString"], info[@"CFBundleVersion"]];
}

- (ServiceProtocolViewModel *)serviceProtocolViewModel
{
    return [[ServiceProtocolViewModel alloc] init];
}

@end
