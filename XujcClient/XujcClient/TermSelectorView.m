//
//  TermSelectorView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TermSelectorView.h"

static NSString * const kTableViewCellIdentifier = @"TableViewCellIdentifier";

@interface TermSelectorView()<UITableViewDataSource>

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
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

@end
