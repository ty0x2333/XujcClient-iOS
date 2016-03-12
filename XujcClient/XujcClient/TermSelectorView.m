//
//  TermSelectorView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TermSelectorView.h"

@interface TermSelectorView()

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
    [self addSubview:_tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    _tableView.backgroundColor = [UIColor greenColor];
}

@end
