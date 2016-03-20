//
//  PersonalViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalViewController.h"
#import "SettingsViewController.h"
#import "PersonalHeaderView.h"
#import "SupportCenterViewController.h"

static NSString * const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

static CGFloat const kPersonalHeaderViewHeight = 140.5f;

@interface PersonalViewController()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PersonalViewModel *viewModel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) PersonalHeaderView *personalHeaderView;

@end

@implementation PersonalViewController

- (instancetype)initWithViewModel:(PersonalViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Personal", nil);
    _personalHeaderView = [[PersonalHeaderView alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(0, kPersonalHeaderViewHeight)} andViewModel:self.viewModel.personalHeaderViewModel];
    _personalHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
    _tableView.tableHeaderView = _personalHeaderView;
    [self.view addSubview:_tableView];
    
    [_personalHeaderView makeConstraints:^(MASConstraintMaker *make) {
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
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier forIndexPath:indexPath];
    TableViewCellViewModel *viewModel = [self.viewModel tableViewCellViewModelForRowAtIndexPath:indexPath];
    cell.accessoryType = viewModel.accessoryType;
    cell.imageView.image = [UIImage imageNamed:viewModel.imageNamed];
    cell.textLabel.text = viewModel.localizedText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SupportCenterViewController *viewController = [[SupportCenterViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.row == 1) {
        SettingsViewController *viewController = [[SettingsViewController alloc] initWithViewModel:[self.viewModel settingsViewModel]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


@end
