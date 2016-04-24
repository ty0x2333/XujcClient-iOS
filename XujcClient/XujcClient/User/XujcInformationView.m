//
//  XujcInformationView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "XujcInformationView.h"
#import "XujcInformationViewModel.h"

@interface XujcInformationView()

@property (strong, nonatomic) UILabel *studentIdLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *gradeLabel;
@property (strong, nonatomic) UILabel *professionalLabel;

@end

@implementation XujcInformationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _studentIdLabel = [[UILabel alloc] init];
        [self addSubview:_studentIdLabel];
        _nameLabel = [[UILabel alloc] init];
        [self addSubview:_nameLabel];
        _gradeLabel = [[UILabel alloc] init];
        [self addSubview:_gradeLabel];
        _professionalLabel = [[UILabel alloc] init];
        [self addSubview:_professionalLabel];
        
        [_studentIdLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.left.equalTo(self);
        }];
        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.studentIdLabel.mas_bottom);
            make.left.right.equalTo(self.studentIdLabel);
        }];
        [_gradeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.left.right.equalTo(self.nameLabel);
        }];
        [_professionalLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gradeLabel.mas_bottom);
            make.left.right.equalTo(self.gradeLabel);
            make.bottom.equalTo(self);
        }];
    }
    return self;
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
    RACChannelTo(self.professionalLabel, text) = RACChannelTo(_viewModel, professional);
}

@end
