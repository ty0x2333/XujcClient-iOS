//
//  TodayEventTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TodayEventTableViewCell.h"
#import "TodayEventTableViewCellViewModel.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa.h>

static CGFloat const kContentInterval = 4.f;

static CGFloat const kLessonNameLabelFontSize = 14.f;

static CGFloat const kSmallLabelFontSize = 12.f;

static CGFloat const kIconSize = 12.f;

@interface TodayEventTableViewCell()

@property (nonatomic, strong) UIImageView *timeIconImageView;
@property (nonatomic, strong) UILabel *lessonNameLabel;
@property (nonatomic, strong) UILabel *lessonLocationLabel;
@property (nonatomic, strong) UILabel *sectionLabel;
@property (nonatomic, strong) UILabel *weekLabel;

@end

@implementation TodayEventTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _lessonNameLabel = [[UILabel alloc] init];
        _lessonNameLabel.numberOfLines = 0;
        _lessonNameLabel.textColor = [UIColor whiteColor];
        _lessonNameLabel.font = [UIFont systemFontOfSize:kLessonNameLabelFontSize];
        [self.contentView addSubview:_lessonNameLabel];
        
        _lessonLocationLabel = [[UILabel alloc] init];
        _lessonLocationLabel.numberOfLines = 0;
        _lessonLocationLabel.textColor = [UIColor whiteColor];
        _lessonLocationLabel.font = [UIFont systemFontOfSize:kSmallLabelFontSize];
        [self.contentView addSubview:_lessonLocationLabel];
        
        _sectionLabel = [[UILabel alloc] init];
        _sectionLabel.textColor = [UIColor whiteColor];
        _sectionLabel.font = [UIFont systemFontOfSize:kSmallLabelFontSize];
        [self.contentView addSubview:_sectionLabel];
        
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textColor = [UIColor whiteColor];
        _weekLabel.font = [UIFont systemFontOfSize:kSmallLabelFontSize];
        [self.contentView addSubview:_weekLabel];
        
        _timeIconImageView = [[UIImageView alloc] init];
        _timeIconImageView.image = [UIImage imageNamed:@"icon_time"];
        [self.contentView addSubview:_timeIconImageView];
        
        [_lessonNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
        }];
        
        [_timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.centerY.equalTo(self.sectionLabel);
            make.width.height.equalTo(@(kIconSize));
        }];
        
        [_sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.timeIconImageView.mas_right).with.offset(kContentInterval);
            make.top.equalTo(self.lessonNameLabel.mas_bottom).with.offset(kContentInterval);
        }];
        
        [_sectionLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_sectionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sectionLabel.mas_right).with.offset(kContentInterval);
            make.top.equalTo(self.lessonNameLabel.mas_bottom).with.offset(kContentInterval);
        }];
        
        [_weekLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_weekLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        [_lessonLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView);
            make.left.equalTo(self.weekLabel.mas_right).with.offset(kContentInterval);
            make.top.equalTo(self.lessonNameLabel.mas_bottom).with.offset(kContentInterval);
        }];
    }
    return self;
}

- (void)setViewModel:(TodayEventTableViewCellViewModel *)viewModel
{
    _viewModel = viewModel;
    RAC(self.lessonNameLabel, text) = [RACObserve(_viewModel, lessonName) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.lessonLocationLabel, text) = [RACObserve(_viewModel, lessonLocation) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.sectionLabel, text) = [RACObserve(_viewModel, sectionDescription) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.weekLabel, text) = [RACObserve(_viewModel, weekDescription) takeUntil:self.rac_prepareForReuseSignal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
