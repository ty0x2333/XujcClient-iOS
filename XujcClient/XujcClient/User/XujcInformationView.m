//
//  XujcInformationView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "XujcInformationView.h"
#import "XujcInformationViewModel.h"
#import "UIView+BorderLine.h"

static CGFloat const kLabelHeight = 35.f;

static CGFloat const kTitleLabelMarginRight = 5.f;

@interface XujcInformationView()

@property (strong, nonatomic) UILabel *studentIdTitleLabel;
@property (strong, nonatomic) UILabel *nameTitleLabel;
@property (strong, nonatomic) UILabel *gradeTitleLabel;
@property (strong, nonatomic) UILabel *majorTitleLabel;

@property (strong, nonatomic) UILabel *studentIdLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *gradeLabel;
@property (strong, nonatomic) UILabel *majorLabel;

@end

@implementation XujcInformationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _studentIdTitleLabel = [self p_createTitleLabel];
        _studentIdTitleLabel.text = NSLocalizedString(@"Student ID", nil);
        [self addSubview:_studentIdTitleLabel];
        _studentIdLabel = [self p_createValueLabel];
        [self addSubview:_studentIdLabel];
        
        _nameTitleLabel = [self p_createTitleLabel];
        _nameTitleLabel.text = NSLocalizedString(@"Name", nil);
        [self addSubview:_nameTitleLabel];
        _nameLabel = [self p_createValueLabel];
        [self addSubview:_nameLabel];
        
        _gradeTitleLabel = [self p_createTitleLabel];
        _gradeTitleLabel.text = NSLocalizedString(@"Grade", nil);
        [self addSubview:_gradeTitleLabel];
        _gradeLabel = [self p_createValueLabel];
        [self addSubview:_gradeLabel];
        
        _majorTitleLabel = [self p_createTitleLabel];
        _majorTitleLabel.text = NSLocalizedString(@"Major", nil);
        [self addSubview:_majorTitleLabel];
        _majorLabel = [self p_createValueLabel];
        [self addSubview:_majorLabel];
        
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    [_studentIdTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@(kLabelHeight));
        make.left.equalTo(self);
        make.width.priorityLow();
    }];
    [_studentIdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.equalTo(@(kLabelHeight));
        make.left.equalTo(self.studentIdTitleLabel.mas_right).with.offset(kTitleLabelMarginRight);
    }];
    
    [_nameTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.studentIdTitleLabel.mas_bottom);
        make.width.height.equalTo(self.studentIdTitleLabel);
        make.left.equalTo(self.studentIdTitleLabel);
    }];
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.studentIdLabel.mas_bottom);
        make.height.equalTo(self.studentIdLabel);
        make.left.right.equalTo(self.studentIdLabel);
    }];
    
    [_gradeTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTitleLabel.mas_bottom);
        make.width.height.equalTo(self.nameTitleLabel);
        make.left.equalTo(self.nameTitleLabel);
    }];
    [_gradeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(self.nameLabel);
        make.left.right.equalTo(self.nameLabel);
    }];
    
    [_majorTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gradeTitleLabel.mas_bottom);
        make.width.height.equalTo(self.gradeTitleLabel);
        make.left.equalTo(self.gradeTitleLabel);
    }];
    [_majorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gradeLabel.mas_bottom);
        make.width.height.equalTo(self.gradeLabel);
        make.left.right.equalTo(self.gradeLabel);
        make.bottom.equalTo(self);
    }];
}

- (void)setViewModel:(XujcInformationViewModel *)viewModel
{
    if (_viewModel == viewModel) {
        return;
    }
    _viewModel = viewModel;
    RACChannelTo(self.studentIdLabel, text) = RACChannelTo(_viewModel, studentId);
    RACChannelTo(self.nameLabel, text) = RACChannelTo(_viewModel, name);
    RACChannelTo(self.gradeLabel, text) = RACChannelTo(_viewModel, grade);
    RACChannelTo(self.majorLabel, text) = RACChannelTo(_viewModel, major);
}

#pragma mark - Helper

- (UILabel *)p_createTitleLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor ty_textGray];
    return label;
}

- (UILabel *)p_createValueLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.ty_borderEdge = UIRectEdgeBottom;
    label.ty_borderWidth = .5f;
    label.ty_borderColor = [UIColor ty_border].CGColor;
    return label;
}

@end
