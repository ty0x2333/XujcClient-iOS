//
//  ScoreViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreViewController.h"
#import "XujcAPI.h"
#import "DynamicData.h"
#import "XujcScore.h"
#import "ScoreTableViewCell.h"
#import <UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>

static NSString* const kTableViewCellIdentifier = @"TableViewCellIdentifier";

static CGFloat const kTableViewSectionHeaderHeight = 5.f;

@interface ScoreViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) ScoreViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScoreViewController

- (instancetype)initWithViewModel:(ScoreViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Score Screen";
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = kTableViewSectionHeaderHeight;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    self.view.backgroundColor = _tableView.backgroundColor;
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    @weakify(self);
    
    [self.viewModel.semesterSelectorViewModel.selectedSemesterIdSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView.mj_header beginRefreshing];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.fetchScoresSignal subscribeNext:^(id x) {
            [self.tableView reloadData];
            TyLogDebug(@"fetchScores success");
            [self.tableView.mj_header endRefreshing];
        } error:^(NSError *error) {
            MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.detailsLabelText = error.localizedDescription;
            [hub hide:YES afterDelay:kErrorHUDShowTime];
            TyLogDebug(@"fetchScores error");
            
            // load data from cache
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel scoreCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    ScoreTableViewCellViewModel *viewModel = [self.viewModel scoreTableViewCellViewModelForRowAtIndex:indexPath.section];
    cell.viewModel = viewModel;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return section == 0 ? CGFLOAT_MIN : tableView.sectionHeaderHeight;
    return tableView.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return 0, will be auto size
    return 0;
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"There is no score data for the current semester.", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
@end
