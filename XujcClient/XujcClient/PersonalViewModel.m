//
//  PersonalViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalViewModel.h"

@interface PersonalViewModel()

@property (strong, nonatomic) NSArray *texts;

@end

@implementation PersonalViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _texts = @[@"Feedback and Help", @"Settings"];
    }
    return self;
}

- (PersonalHeaderViewModel *)personalHeaderViewModel
{
    return [[PersonalHeaderViewModel alloc] init];
}

- (SettingsViewModel *)settingsViewModel
{
    return [[SettingsViewModel alloc] init];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return _texts.count;
}

- (TableViewCellViewModel *)tableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellViewModel *viewModel = [[TableViewCellViewModel alloc] init];
    viewModel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    viewModel.imageNamed = @"settings";
    viewModel.localizedText = NSLocalizedString([_texts objectAtIndex:indexPath.row], nil);
    return viewModel;
}

@end
