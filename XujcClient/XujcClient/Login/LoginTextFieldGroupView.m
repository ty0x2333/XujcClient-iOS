//
//  LoginTextFieldGroupView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/3.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LoginTextFieldGroupView.h"

@interface LoginTextFieldGroupView()

@property (assign, nonatomic) CGFloat itemHeight;
@property (strong, nonatomic) MASConstraint *heightConstraint;

@end

@implementation LoginTextFieldGroupView

- (instancetype)initWithItemHeight:(CGFloat)itemHeight
{
    if (self = [super init]) {
        _itemHeight = itemHeight;
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    NSInteger subviewsCount = self.subviews.count;
    [view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subviewsCount == 1 ? self : [self.subviews objectAtIndex:subviewsCount - 2].mas_bottom);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(_itemHeight));
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        [self.heightConstraint uninstall];
        self.heightConstraint = make.bottom.equalTo(view);
    }];
}

@end
