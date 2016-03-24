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

static CGFloat const kAvatarImageViewHeight = 100.f;
static CGFloat const kAvatarMarginRight = 5.f;

static CGFloat const kContentMarginTop = 10.f;
static CGFloat const kContentMarginHorizontal = 5.f;

static CGFloat const kNicknameLabelHeight = 25.f;

@interface UserDetailViewController()

@property (strong, nonatomic) UserDetailViewModel *viewModel;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) AvatarImageView *avatarImageView;

@property (strong, nonatomic) UILabel *nicknameLabel;

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
    _nicknameLabel.preferredMaxLayoutWidth = 100;
    [_scrollView addSubview:_nicknameLabel];
    
    [_nicknameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(kAvatarMarginRight);
        make.width.equalTo(self.scrollView).with.offset(-2 * kContentMarginHorizontal - kAvatarImageViewHeight - kAvatarMarginRight);
        make.height.equalTo(@(kNicknameLabelHeight));
    }];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
    RAC(self.nicknameLabel, text) = RACObserve(self.viewModel, nickname);
    @weakify(self);
    [RACObserve(self.viewModel, avatar) subscribeNext:^(NSString *avatarURL) {
        @strongify(self);
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarURL] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    }];
}

@end
