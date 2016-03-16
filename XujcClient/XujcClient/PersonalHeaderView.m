//
//  PersonalHeaderView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/16.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalHeaderView.h"

static CGFloat const kAvatarImageViewMarginTop = 10.f;

static CGFloat const kNicknameLabelMarginVertical = 5.f;

static CGFloat const kAvatarImageViewHeight = 100.f;

static CGFloat const kAvatarImageViewCornerRadius = kAvatarImageViewHeight / 2.f;

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
        _avatarImageView.layer.cornerRadius = kAvatarImageViewCornerRadius;
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        
        _nicknameLabel = [[UILabel alloc] init];
        [self addSubview:_nicknameLabel];
        
        [_avatarImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(kAvatarImageViewMarginTop);
            make.centerX.equalTo(self);
            make.width.height.equalTo(@(kAvatarImageViewHeight));
        }];
        
        [_nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(kNicknameLabelMarginVertical);
            make.centerX.equalTo(self.avatarImageView);
        }];
        
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.nicknameLabel).with.offset(kNicknameLabelMarginVertical);
        }];
        
        RAC(self.nicknameLabel, text) = RACObserve(self.viewModel, nickname);
        
#warning test
        _avatarImageView.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
