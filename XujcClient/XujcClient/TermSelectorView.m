//
//  TermSelectorView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TermSelectorView.h"
#import "TermTableViewCell.h"

static NSString * const kTermTableViewCellIdentifier = @"kTermTableViewCellIdentifier";

@interface TermSelectorView()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TermSelectorView

- (instancetype)init
{
    if (self = [super init]) {
        [self commentInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
    [_tableView registerClass:[TermTableViewCell class] forCellReuseIdentifier:kTermTableViewCellIdentifier];
    [self addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor greenColor];
    
    @weakify(self);
    [[RACObserve(_tableView, contentSize) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        [self setNeedsLayout];
        [self layoutIfNeeded];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TermTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTermTableViewCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

@end
