//
//  SettingsViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/27.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsViewModel.h"
#import "DynamicData.h"

static NSString* const kTableCellReuseIdentifier = @"TableCellReuseIdentifier";

@interface SettingsViewController()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SettingsViewModel *viewModel;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SettingsViewController

- (instancetype)initWithViewModel:(SettingsViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableCellReuseIdentifier];
    
    @weakify(self);
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    [[self.viewModel.executeLoginout.executing filter:^BOOL(NSNumber *value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.executeLoginout execute:nil];
}

@end
