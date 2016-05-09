//
//  PersonalHeaderView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/16.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalHeaderView.h"
#import <MMPopupItem.h>
#import <UIImageView+WebCache.h>
#import "EditableAvatarImageView.h"

static CGFloat const kAvatarImageViewMarginTop = 10.f;

static CGFloat const kNicknameLabelMarginVertical = 5.f;

static CGFloat const kAvatarImageViewHeight = 100.f;

@interface PersonalHeaderView()

@property (strong, nonatomic) PersonalHeaderViewModel *viewModel;

@property (strong, nonatomic) EditableAvatarImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;

@end

@implementation PersonalHeaderView

- (instancetype)initWithFrame:(CGRect)frame andViewModel:(PersonalHeaderViewModel *)viewModel
{
    if (self = [super initWithFrame:frame]) {
        _viewModel = viewModel;
        self.backgroundColor = [UIColor whiteColor];
        _avatarImageView = [[EditableAvatarImageView alloc] initWithViewModel:[_viewModel editableAvatarImageViewModel]];
        [self addSubview:_avatarImageView];
        
        _nicknameLabel = [[UILabel alloc] init];
        [self addSubview:_nicknameLabel];
        
        [_avatarImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(kAvatarImageViewMarginTop);
            make.centerX.equalTo(self);
            make.width.equalTo(@(kAvatarImageViewHeight));
        }];
        
        [_nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(kNicknameLabelMarginVertical);
            make.centerX.equalTo(self.avatarImageView);
        }];
        
        [self makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.nicknameLabel).with.offset(kNicknameLabelMarginVertical);
        }];
        
        @weakify(self);
        RAC(self.nicknameLabel, text) = RACObserve(self.viewModel, nickname);
        [RACObserve(self.viewModel, avatar) subscribeNext:^(NSString *avatarURL) {
            @strongify(self);
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        }];
    }
    return self;
}

@end
