//
//  PersonalViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalViewController.h"
#import "SettingsViewController.h"
#import <ReactiveCocoa.h>

@interface PersonalViewController()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation PersonalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Personal", nil);
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

@end
