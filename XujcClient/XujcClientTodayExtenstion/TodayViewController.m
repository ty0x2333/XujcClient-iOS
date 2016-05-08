//
//  TodayViewController.m
//  XujcClientTodayExtenstion
//
//  Created by 田奕焰 on 16/5/7.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CacheUtils.h"
#import "XujcSemesterModel.h"
#import <Masonry/Masonry.h>
#import "NSDate+Week.h"
#import "LessonTimeCalculator.h"
#import "TodayViewModel.h"
#import "TodayEventTableViewCell.h"
#import <ReactiveCocoa.h>
#import "RACSignal+TYDebugging.h"
#import "NSString+Safe.h"

static CGFloat const kContentInterval = 8.f;

static CGFloat const kContentMarginHorizontal = 15.f;

static CGFloat const kContentMarginVertical = 10.f;

static CGFloat const kSemesterLabelFont = 14.f;
static CGFloat const kNextLessonTitleLabelFont = 14.f;

static CGFloat const kTableViewRowHeight = 50.f;

static NSString * const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource>

@property (nonatomic, strong) TodayViewModel *viewModel;

@property (nonatomic, strong) MASConstraint *tableViewHeightConstraint;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *semesterLabel;

@property (nonatomic, strong) UILabel *nextLessonTitleLabel;

@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewModel = [[TodayViewModel alloc] init];
    
    _contentView = [[UIView alloc] init];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kContentMarginHorizontal);
        make.right.equalTo(self.view).with.offset(-kContentMarginHorizontal);
        make.top.equalTo(self.view).with.offset(kContentMarginVertical).priorityMedium();
        make.bottom.equalTo(self.view).with.offset(-kContentMarginVertical).priorityMedium();
    }];
    
    _semesterLabel = [[UILabel alloc] init];
    _semesterLabel.textAlignment = NSTextAlignmentCenter;
    _semesterLabel.textColor = [UIColor whiteColor];
    _semesterLabel.font = [UIFont systemFontOfSize:kSemesterLabelFont];
    [_contentView addSubview:_semesterLabel];
    
    [_semesterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _warningLabel = [[UILabel alloc] init];
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    _warningLabel.textColor = [UIColor whiteColor];
    _warningLabel.font = [UIFont systemFontOfSize:kSemesterLabelFont];
    [_contentView addSubview:_warningLabel];
    
    [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.semesterLabel.mas_bottom).with.offset(kContentInterval);
        make.bottom.equalTo(self.contentView).priorityLow();
    }];
    
    _nextLessonTitleLabel = [[UILabel alloc] init];
    _nextLessonTitleLabel.textColor = [UIColor whiteColor];
    _nextLessonTitleLabel.text = @"下节课";
    _nextLessonTitleLabel.font = [UIFont systemFontOfSize:kNextLessonTitleLabelFont];
    [_contentView addSubview:_nextLessonTitleLabel];
    
    [_nextLessonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.semesterLabel.mas_bottom).with.offset(kContentInterval);
    }];
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.rowHeight = kTableViewRowHeight;
    [_tableView registerClass:[TodayEventTableViewCell class] forCellReuseIdentifier:kTableViewCellReuseIdentifier];
    [_contentView addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.tableViewHeightConstraint = make.height.equalTo(@(0));
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.nextLessonTitleLabel.mas_bottom).with.offset(kContentInterval);
        make.bottom.equalTo(self.contentView);
    }];
    
    RACSignal *semesterNameSignal = [RACObserve(_viewModel, semesterName) setNameWithFormat:@"semesterNameSignal"];
    
    RAC(self.semesterLabel, text) = [semesterNameSignal ty_logAll];
    
    RACSignal *nextEventsEmptySignal = [[RACObserve(self.viewModel, nextEventsCount) map:^id(id value) {
        return @([value integerValue] < 1);
    }] setNameWithFormat:@"nextEventsEmptySignal"];
    
    RAC(self.nextLessonTitleLabel, hidden) = [nextEventsEmptySignal ty_logAll];
    RAC(self.warningLabel, hidden) = [nextEventsEmptySignal not];
    
    RACSignal *semesterEmptySignal = [semesterNameSignal map:^id(id value) {
        return @([NSString isEmpty:value]);
    }];

    RAC(self.warningLabel, text) = [semesterEmptySignal map:^id(id value) {
        return [value boolValue] ? @"暂无学期数据" : @"今天已经没有后续课程";
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    @weakify(self);
    [_viewModel.fetchDataSignal subscribeNext:^(NSNumber *nextEventsCount) {
        @strongify(self);
        [self.tableView reloadData];
        NSInteger numberOfRow = [_viewModel numberOfRowsInSection:0];
        CGFloat rowHeight = self.tableView.rowHeight;
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.tableViewHeightConstraint uninstall];
            self.tableViewHeightConstraint = make.height.equalTo(@(numberOfRow * rowHeight));
        }];
        [self.tableView updateConstraints];
    }];
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TodayEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier forIndexPath:indexPath];
    cell.viewModel = [_viewModel todayEventTableViewCellViewModelForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - NCWidgetProviding

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

@end
