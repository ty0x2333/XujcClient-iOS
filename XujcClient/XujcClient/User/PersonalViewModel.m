//
//  PersonalViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/17.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalViewModel.h"
#import "UserModel.h"

@interface PersonalViewModel()

@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *texts;
@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *imageNames;

@end

@implementation PersonalViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _texts = @[@[@"Personal Detail"], @[@"Feedback and Help", @"Settings"], @[@"Share"]];
        _imageNames = @[@[@"cell_icon_detail"], @[@"cell_icon_home", @"cell_icon_settings"], @[@"cell_icon_share"]];
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
    UserDetailViewModel *viewModel = [[UserDetailViewModel alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    RACSignal *userSignal = [[userDefaults ty_channelTerminalForUser] map:^id(NSData *value) {
        UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:value];
        return user;
    }];
    
    RAC(viewModel, nickname) = [[[userSignal map:^id(UserModel *value) {
        return value.nikename;
    }] setNameWithFormat:@"PersonalViewModel nikenameSignal"] logAll];
    
    RAC(viewModel, avatar) = [[[userSignal map:^id(UserModel *value) {
        return value.avatar;
    }] setNameWithFormat:@"PersonalViewModel avatarSignal"] logAll];
    
    RAC(viewModel, email) = [[[userSignal map:^id(UserModel *value) {
        return value.email;
    }] setNameWithFormat:@"PersonalViewModel emailSignal"] logAll];
    
    return viewModel;
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
    viewModel.imageNamed = [[_imageNames objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    viewModel.localizedText = NSLocalizedString([[_texts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row], nil);
    viewModel.accessoryType = indexPath.section != 2 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return viewModel;
}

- (SupportCenterViewModel *)supportCenterViewModel
{
    return [[SupportCenterViewModel alloc] init];
}

@end
