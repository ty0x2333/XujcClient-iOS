//
//  SemesterSelectorView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterSelectorView.h"
#import "SemesterTableViewCell.h"

static NSString * const kSemesterTableViewCellIdentifier = @"kSemesterTableViewCellIdentifier";

@interface SemesterSelectorView()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SemesterSelectorViewModel *viewModel;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SemesterSelectorView

- (instancetype)initWithViewModel:(SemesterSelectorViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
        [self commentInit];
    }
    return self;
}

- (void)commentInit
{
    _tableView = [[UITableView alloc] init];
    _tableView.autoresizesSubviews = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[SemesterTableViewCell class] forCellReuseIdentifier:kSemesterTableViewCellIdentifier];
    [self addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor greenColor];
    
    @weakify(self);
    [[RACObserve(_tableView, contentSize) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
    
    [_viewModel.fetchSemestersSignal subscribeNext:^(id x) {
        
    } completed:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = SCREEN_SIZE.width;
    _tableView.frame = (CGRect){_tableView.frame.origin, CGSizeMake(width, 4 * 50.f)};
    self.frame = (CGRect){self.frame.origin, CGSizeMake(width, CGRectGetHeight(_tableView.bounds))};
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel semesterCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SemesterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSemesterTableViewCellIdentifier forIndexPath:indexPath];
    cell.viewModel = [self.viewModel semesterTableViewCellViewModelAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.viewModel.selectedIndex = indexPath.row;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

@end
