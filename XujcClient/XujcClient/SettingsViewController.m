//
//  SettingsViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/27.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SettingsViewController.h"
#import <ReactiveCocoa.h>

static NSString* const kTableCellReuseIdentifier = @"TableCellReuseIdentifier";

@interface SettingsViewController()<UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCellReuseIdentifier];
    
    @weakify(self);
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Logout", nil);
    return cell;
}

@end
