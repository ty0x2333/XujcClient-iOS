//
//  ScoreViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreViewController.h"

static NSString* const kTableViewCellIdentifier = @"TableViewCellIdentifier";

@interface ScoreViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"成绩查询";
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = [self.view bounds];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [[UITableViewCell alloc] initWithStyle:<#(UITableViewCellStyle)#> reuseIdentifier:<#(nullable NSString *)#>]
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"课程名称";
    cell.detailTextLabel.text = @"分数";
    return cell;
}
@end
