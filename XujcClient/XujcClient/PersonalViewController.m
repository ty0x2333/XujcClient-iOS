//
//  PersonalViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalViewController.h"

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
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

@end
