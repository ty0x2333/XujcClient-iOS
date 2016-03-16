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

static NSString * const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

@interface PersonalViewController()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) PersonalView *personalView;

@end

@implementation PersonalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Personal", nil);
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
    
    _personalView = [[PersonalView alloc] initWithFrame:CGRectMake(0, 0, 0, 135)];
    _tableView.tableHeaderView = _personalView;
    [self.view addSubview:_tableView];
    
    [_personalView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView);
        make.width.equalTo(self.tableView);
    }];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.bottom.equalTo(self.mas_bottomLayoutGuideBottom);
    }];
    
//    UIButton *settingsButton = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(25, 25)}];
//    [settingsButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
//    UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
//    self.navigationItem.rightBarButtonItem = settingsButtonItem;
//    
//    @weakify(self);
//    settingsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self);
//        SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
//        [self.navigationController pushViewController:settingsViewController animated:YES];
//        return [RACSignal empty];
//    }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"settings"];
    cell.textLabel.text = NSLocalizedString(@"Settings", nil);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}


@end
