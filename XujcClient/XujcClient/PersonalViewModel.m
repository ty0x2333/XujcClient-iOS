//
//  PersonalViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalViewModel.h"

@interface PersonalViewModel()

@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *texts;
@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *imageNames;

@end

@implementation PersonalViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _texts = @[@[@"Personal Detail"], @[@"Feedback and Help", @"Settings"]];
        _imageNames = @[@[@"cell_icon_home"], @[@"cell_icon_home", @"cell_icon_settings"]];
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

- (UserDetailViewModel *)userDetailViewModel
{
    return [[UserDetailViewModel alloc] init];
}

- (NSInteger)numberOfSections
{
    return _texts.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [[_texts objectAtIndex:section] count];
}

- (TableViewCellViewModel *)tableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCellViewModel *viewModel = [[TableViewCellViewModel alloc] init];
    viewModel.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    viewModel.imageNamed = [[_imageNames objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    viewModel.localizedText = NSLocalizedString([[_texts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row], nil);
    return viewModel;
}

- (SupportCenterViewModel *)supportCenterViewModel
{
    return [[SupportCenterViewModel alloc] init];
}

@end
