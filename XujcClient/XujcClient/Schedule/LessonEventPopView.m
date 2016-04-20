//
//  LessonEventPopView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LessonEventPopView.h"
#import "LessonEventPopViewModel.h"
#import "ScheduleTheme.h"

static CGFloat const kContentMargin = 13.f;

static CGFloat const kTitleLabelFontSize = 18.f;

static CGFloat const kLocationLabelFontSize = 16.f;

@interface LessonEventPopView()

@property (nonatomic, strong) LessonEventPopViewModel *viewModel;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *weekIntervalLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *startEndWeek;

@end

@implementation LessonEventPopView

- (instancetype)initWithViewModel:(LessonEventPopViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
        
        self.type = MMPopupTypeCustom;
        
        _backgroundView = [[UIView alloc] init];
        [self addSubview:_backgroundView];
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.width.lessThanOrEqualTo(@(SCREEN_SIZE.width * .75f));
        }];
        _backgroundView.layer.cornerRadius = 5.0f;
        _backgroundView.clipsToBounds = YES;
        _backgroundView.backgroundColor = [ScheduleTheme backgroundColorHighlighted:YES];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [ScheduleTheme textColorHighlighted:YES];
        _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
        _titleLabel.numberOfLines = 0;
        [_backgroundView addSubview:_titleLabel];
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.backgroundView).insets(UIEdgeInsetsMake(kContentMargin, kContentMargin, 0, kContentMargin));
        }];
        
        _weekIntervalLabel = [[UILabel alloc] init];
        _weekIntervalLabel.textColor = [ScheduleTheme textColorHighlighted:YES];
        _weekIntervalLabel.font = [UIFont systemFontOfSize:kLocationLabelFontSize];
        _weekIntervalLabel.numberOfLines = 0;
        [_backgroundView addSubview:_weekIntervalLabel];
        [_weekIntervalLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(kContentMargin);
            make.leading.trailing.equalTo(self.backgroundView).insets(UIEdgeInsetsMake(0, kContentMargin, 0, kContentMargin));
        }];
        
        _startEndWeek = [[UILabel alloc] init];
        _startEndWeek.textColor = [ScheduleTheme textColorHighlighted:YES];
        _startEndWeek.font = [UIFont systemFontOfSize:kLocationLabelFontSize];
        _startEndWeek.numberOfLines = 0;
        [_backgroundView addSubview:_startEndWeek];
        [_startEndWeek makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weekIntervalLabel.mas_bottom).with.offset(kContentMargin);
            make.leading.trailing.equalTo(self.backgroundView).insets(UIEdgeInsetsMake(0, kContentMargin, 0, kContentMargin));
        }];
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [ScheduleTheme textColorHighlighted:YES];
        _locationLabel.font = [UIFont systemFontOfSize:kLocationLabelFontSize];
        _locationLabel.numberOfLines = 0;
        [_backgroundView addSubview:_locationLabel];
        [_locationLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startEndWeek.mas_bottom).with.offset(kContentMargin);
            make.bottom.leading.trailing.equalTo(self.backgroundView).insets(UIEdgeInsetsMake(0, kContentMargin, kContentMargin, kContentMargin));
        }];
        
        RACChannelTo(self.titleLabel, text) = RACChannelTo(_viewModel, name);
        RACChannelTo(self.locationLabel, text) = RACChannelTo(_viewModel, location);
        RACChannelTo(self.weekIntervalLabel, text) = RACChannelTo(_viewModel, weekInterval);
        RACChannelTo(self.startEndWeek, text) = RACChannelTo(_viewModel, startEndWeek);
    }
    return self;
}

@end
