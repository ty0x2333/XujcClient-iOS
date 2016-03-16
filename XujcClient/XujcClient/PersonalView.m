//
//  PersonalView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/16.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "PersonalView.h"

static CGFloat const kAvatarImageViewMarginTop = 10.f;

@interface PersonalView()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nicknameLabel;

@end

@implementation PersonalView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
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
        
#warning test
        _avatarImageView.backgroundColor = [UIColor redColor];
        _nicknameLabel.text = @"asdklfklsajdf";
        
    }
    return self;
}

@end
