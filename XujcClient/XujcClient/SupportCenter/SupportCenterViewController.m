//
//  SupportCenterViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SupportCenterViewController.h"
#import <Instabug/Instabug.h>
#import "ServiceProtocolViewController.h"

static NSString * const kTableViewCellIdentifier = @"TableViewCellIdentifier";
static CGFloat const kTableViewTableFooterHeight = 40.f;
static CGFloat const kVersionLabelFontSize = 14.f;

@interface SupportCenterViewController()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SupportCenterViewModel *viewModel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UILabel *versionLabel;

@end

@implementation SupportCenterViewController

- (instancetype)initWithViewModel:(SupportCenterViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Support Center Screen";
    self.title = NSLocalizedString(@"Feedback and Help", nil);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.sectionFooterHeight = 0;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    [self.view addSubview:_tableView];
    
    _versionLabel = [[UILabel alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(0, kTableViewTableFooterHeight)}];
    _versionLabel.font = [UIFont systemFontOfSize:kVersionLabelFontSize];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    _versionLabel.textColor = [UIColor ty_textGray];
    _versionLabel.text = [self.viewModel versionDescription];
    _tableView.tableFooterView = _versionLabel;
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    TableViewCellViewModel *viewModel = [self.viewModel tableViewCellViewModelForRowAtIndexPath:indexPath];
    cell.textLabel.text = viewModel.localizedText;
    cell.selectionStyle = viewModel.selectionStyle;
    if (indexPath.section == 1 && indexPath.row == 0) {
        UISwitch *switchView = [[UISwitch alloc] init];
        RAC(switchView, on) = [RACChannelTo(self.viewModel, shakingReportStatus) takeUntil:cell.rac_prepareForReuseSignal];
        [switchView.rac_newOnChannel subscribe:RACChannelTo(self.viewModel, shakingReportStatus)];
        cell.accessoryView = switchView;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [Instabug invokeWithInvocationMode:IBGInvocationModeFeedbackSender];
    } else if (indexPath.section == 2) {
        ServiceProtocolViewController *viewController = [[ServiceProtocolViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end
