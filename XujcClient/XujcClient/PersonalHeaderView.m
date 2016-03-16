//
//  PersonalHeaderView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/16.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalHeaderView.h"

static CGFloat const kAvatarImageViewMarginTop = 10.f;

@interface PersonalHeaderView()

@property (strong, nonatomic) PersonalHeaderViewModel *viewModel;

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;

@end

@implementation PersonalHeaderView

- (instancetype)initWithFrame:(CGRect)frame andViewModel:(PersonalHeaderViewModel *)viewModel
{
    if (self = [super initWithFrame:frame]) {
        _viewModel = viewModel;
        self.backgroundColor = [UIColor whiteColor];
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 100.f / 2.f;
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        
        _nicknameLabel = [[UILabel alloc] init];
        [self addSubview:_nicknameLabel];
        
        [_avatarImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(kAvatarImageViewMarginTop);
            make.centerX.equalTo(self);
            make.width.equalTo(@(100));
            make.height.equalTo(@(100));
        }];
        
        [_nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom);
            make.centerX.equalTo(self.avatarImageView);
        }];
        
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.nicknameLabel);
        }];
        
        RAC(self.nicknameLabel, text) = RACObserve(self.viewModel, nickname);
        
#warning test
        _avatarImageView.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
