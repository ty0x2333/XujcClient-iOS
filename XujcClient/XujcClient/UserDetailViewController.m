//
//  UserDetailViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserDetailViewModel.h"
#import "AvatarImageView.h"
#import "UIView+BorderLine.h"
#import <UIImageView+WebCache.h>

static CGFloat const kAvatarImageViewHeight = 80.f;
static CGFloat const kAvatarMarginRight = 15.f;

static CGFloat const kContentMarginTop = 10.f;
static CGFloat const kContentMarginHorizontal = 10.f;

@interface UserDetailViewController()

@property (strong, nonatomic) UserDetailViewModel *viewModel;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) AvatarImageView *avatarImageView;

@property (strong, nonatomic) UILabel *nicknameLabel;
@property (strong, nonatomic) UILabel *emailLabel;

@end

@implementation UserDetailViewController

- (instancetype)initWithViewModel:(UserDetailViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Personal Detail", nil);
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _avatarImageView = [[AvatarImageView alloc] init];
    [_scrollView addSubview:_avatarImageView];
    
    [_avatarImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).with.offset(kContentMarginTop);
        make.leading.equalTo(self.scrollView).with.offset(kContentMarginHorizontal);
        make.width.equalTo(@(kAvatarImageViewHeight));
    }];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.ty_borderColor = [UIColor ty_border].CGColor;
    _nicknameLabel.ty_borderEdge = UIRectEdgeBottom;
    [_scrollView addSubview:_nicknameLabel];
    
    _emailLabel = [[UILabel alloc] init];
    [_scrollView addSubview:_emailLabel];
    
    [_nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageView.centerY);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(kAvatarMarginRight);
        make.width.equalTo(self.scrollView).with.offset(-2 * kContentMarginHorizontal - kAvatarImageViewHeight - kAvatarMarginRight);
        make.height.equalTo(self.avatarImageView).with.multipliedBy(.5f);
    }];
    
    [_emailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageView.mas_bottom);
        make.left.equalTo(self.nicknameLabel);
        make.width.equalTo(self.nicknameLabel);
        make.height.equalTo(self.nicknameLabel);
    }];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
    RAC(self.nicknameLabel, text) = RACObserve(self.viewModel, nickname);
    RAC(self.emailLabel, text) = RACObserve(self.viewModel, email);
    @weakify(self);
    [RACObserve(self.viewModel, avatar) subscribeNext:^(NSString *avatarURL) {
        @strongify(self);
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }];
}

@end
