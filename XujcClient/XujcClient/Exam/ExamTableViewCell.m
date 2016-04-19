//
//  ExamTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ExamTableViewCell.h"
#import "ExamTableViewCellViewModel.h"

static const CGFloat kContentEdgeInsetVertical = 8.f;
static const CGFloat kContentEdgeHorizontal = 12.f;

static const CGFloat kFontSize = 12.f;

@interface ExamTableViewCell()

@property (strong, nonatomic) UILabel *lessonNameLabel;

@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *weekLabel;

@property (strong, nonatomic) UILabel *locationLabel;

@property (strong, nonatomic) UILabel *wayLabel;

@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation ExamTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _lessonNameLabel = [[UILabel alloc] init];
        _lessonNameLabel.textColor = [UIColor ty_textBlack];
        _lessonNameLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:_lessonNameLabel];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.contentView addSubview:_statusLabel];

        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor ty_textBlack];
        _dateLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.informationDetailView addSubview:_dateLabel];
        
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textColor = [UIColor ty_textBlack];
        _weekLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.informationDetailView addSubview:_weekLabel];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor ty_textBlack];
        _locationLabel.font = [UIFont systemFontOfSize:kFontSize];
        _locationLabel.numberOfLines = 0;
        [self.informationDetailView addSubview:_locationLabel];
        
        _wayLabel = [[UILabel alloc] init];
        _wayLabel.textColor = [UIColor ty_textBlack];
        _wayLabel.font = [UIFont systemFontOfSize:kFontSize];
        [self.informationDetailView addSubview:_wayLabel];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor ty_textBlack];
        _nameLabel.font = [UIFont systemFontOfSize:kFontSize];
        _nameLabel.numberOfLines = 0;
        [self.informationDetailView addSubview:_nameLabel];

        @weakify(self);
        [_statusLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.trailing.equalTo(self.contentView).offset(-kContentEdgeHorizontal);
            make.height.equalTo(self.lessonNameLabel);
            make.top.equalTo(self.lessonNameLabel);
        }];
        
        [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.informationDetailView.mas_top).with.offset(kContentEdgeInsetVertical);
            make.trailing.equalTo(self.informationDetailView);
            make.leading.equalTo(self.lessonNameLabel);
        }];
        
        [_weekLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.dateLabel.mas_bottom);
            make.trailing.equalTo(self.informationDetailView);
            make.leading.equalTo(self.lessonNameLabel);
        }];
        
        [_locationLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.weekLabel.mas_bottom);
            make.trailing.equalTo(self.informationDetailView);
            make.leading.equalTo(self.lessonNameLabel);
        }];
        
        [_wayLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.locationLabel.mas_bottom);
            make.trailing.equalTo(self.informationDetailView);
            make.leading.equalTo(self.lessonNameLabel);
        }];

        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.wayLabel.mas_bottom);
            make.trailing.equalTo(self.informationDetailView);
            make.leading.equalTo(self.lessonNameLabel);
            make.bottom.equalTo(self.informationDetailView.mas_bottom).with.offset(-kContentEdgeInsetVertical);
        }];
        
        [_lessonNameLabel makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.leading.equalTo(self.contentView).offset(kContentEdgeHorizontal);
            make.top.equalTo(self.contentView).offset(kContentEdgeInsetVertical);
            make.right.equalTo(self.statusLabel.mas_left).with.offset(-kContentEdgeInsetVertical);
            make.bottom.equalTo(self.informationDetailView.mas_top).with.offset(-kContentEdgeInsetVertical);
        }];
    }
    return self;
}

- (void)setViewModel:(ExamTableViewCellViewModel *)viewModel
{
    if (_viewModel == viewModel) {
        return;
    }
    _viewModel = viewModel;
    RACSignal *scoreSignal = [RACObserve(self.viewModel, status) takeUntil:self.rac_prepareForReuseSignal];
    RAC(_statusLabel, text) = scoreSignal;
    
    RAC(_statusLabel, textColor) = [scoreSignal map:^id(NSString *value) {
        return [value isEqualToString:@"未开始"] ? [UIColor ty_textGreen] : [UIColor ty_textRed];
    }];
    
    RAC(_lessonNameLabel, text) = [RACObserve(self.viewModel, lessonName) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(_dateLabel, text) = [RACObserve(self.viewModel, dateDescription) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(_weekLabel, text) = [RACObserve(self.viewModel, weekDescription) takeUntil:self.rac_prepareForReuseSignal];

    RAC(_nameLabel, text) = [RACObserve(self.viewModel, name) takeUntil:self.rac_prepareForReuseSignal];
    RAC(_locationLabel, text) = [RACObserve(self.viewModel, location) takeUntil:self.rac_prepareForReuseSignal];
    RAC(_wayLabel, text) = [RACObserve(self.viewModel, way) takeUntil:self.rac_prepareForReuseSignal];
}

@end
