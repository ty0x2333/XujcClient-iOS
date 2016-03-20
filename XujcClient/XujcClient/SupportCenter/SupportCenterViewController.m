//
//  SupportCenterViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SupportCenterViewController.h"
#import <Instabug/Instabug.h>

static NSString * const kTableViewCellIdentifier = @"TableViewCellIdentifier";

@interface SupportCenterViewController()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SupportCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Feedback and Help", nil);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self.view addSubview:_tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Feedback problems", nil);
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [Instabug invokeWithInvocationMode:IBGInvocationModeFeedbackSender];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end
