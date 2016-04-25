//
//  ExamViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ExamViewController.h"
#import "ExamTableViewCell.h"
#import <UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>

static NSString* const kTableViewCellIdentifier = @"TableViewCellIdentifier";

static CGFloat const kTableViewSectionHeaderHeight = 5.f;

@interface ExamViewController()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) ExamViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ExamViewController

- (instancetype)initWithViewModel:(ExamViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Exam";
    self.title = NSLocalizedString(@"Exam Arrangement", nil);
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = kTableViewSectionHeaderHeight;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ExamTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    self.view.backgroundColor = _tableView.backgroundColor;
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    @weakify(self);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.fetchExamsSignal subscribeNext:^(id x) {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } error:^(NSError *error) {
            MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.detailsLabelText = error.localizedDescription;
            [hub hide:YES afterDelay:kErrorHUDShowTime];
            
            // load data from cache
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];

    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel examCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    cell.viewModel = [self.viewModel examTableViewCellViewModelForRowAtIndex:indexPath.section];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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
    NSString *text = NSLocalizedString(@"There is no exam data.", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
