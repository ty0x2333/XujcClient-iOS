//
//  SupportCenterViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/21.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SupportCenterViewModel.h"

@interface SupportCenterViewModel()

@property (strong, nonatomic) NSArray *texts;

@end

@implementation SupportCenterViewModel

- (instancetype)init
{
    if (self = [super init]) {
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
    return viewModel;
}

@end
