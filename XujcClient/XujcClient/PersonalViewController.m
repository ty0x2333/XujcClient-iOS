//
//  PersonalViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalViewController.h"
#import "SettingsViewController.h"
#import "PersonalView.h"

@interface PersonalViewController()

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) PersonalView *personalView;

@end

@implementation PersonalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Personal", nil);
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _personalView = [[PersonalView alloc] init];
    _tableView.tableHeaderView = _personalView;
    [self.view addSubview:_tableView];
    
    [_personalView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.width.equalTo(self.tableView);
    }];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(25, 25)}];
    [settingsButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingsButtonItem;
    
    @weakify(self);
    settingsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:settingsViewController animated:YES];
        return [RACSignal empty];
    }];
}

@end
