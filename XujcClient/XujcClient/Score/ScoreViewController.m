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

static NSString* const kTableViewCellIdentifier = @"TableViewCellIdentifier";

static CGFloat const kTableViewSectionHeaderHeight = 5.f;

@interface ScoreViewController ()<UITableViewDataSource, UITableViewDelegate>

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
    self.title = @"成绩查询";
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = kTableViewSectionHeaderHeight;
    _tableView.sectionFooterHeight = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ScoreTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    self.view.backgroundColor = _tableView.backgroundColor;
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
    [self.viewModel.fetchScoresSignal subscribeNext:^(id x) {
        TyLogDebug(@"success");
        [_tableView reloadData];
    } error:^(NSError *error) {
        TyLogDebug(@"error");
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

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TyLogDebug(@"didDeselectRowAtIndexPath: %d", indexPath.row);
//    _currentSelected = indexPath.row;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TyLogDebug(@"didSelectRowAtIndexPath: %d", indexPath.row);
//    _currentSelected = _currentSelected == indexPath.row ? -1 : indexPath.row;
////    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [tableView reloadData];
//}

@end
