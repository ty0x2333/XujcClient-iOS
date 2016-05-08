//
//  TodayEventView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TodayEventView.h"
#import <Masonry/Masonry.h>

static CGFloat const kContentInterval = 4.f;

static CGFloat const kLessonNameLabelFontSize = 14.f;

static CGFloat const kSmallLabelFontSize = 12.f;

static CGFloat const kIconSize = 12.f;

@interface TodayEventView()

@property (nonatomic, strong) UIImageView *timeIconImageView;
@property (nonatomic, strong) UILabel *lessonNameLabel;
@property (nonatomic, strong) UILabel *lessonLocationLabel;
@property (nonatomic, strong) UILabel *sectionLabel;

@end

@implementation TodayEventView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _lessonNameLabel = [[UILabel alloc] init];
        _lessonNameLabel.numberOfLines = 0;
        _lessonNameLabel.textColor = [UIColor whiteColor];
        _lessonNameLabel.font = [UIFont systemFontOfSize:kLessonNameLabelFontSize];
        [self addSubview:_lessonNameLabel];
        
        _lessonLocationLabel = [[UILabel alloc] init];
        _lessonLocationLabel.numberOfLines = 0;
        _lessonLocationLabel.textColor = [UIColor whiteColor];
        _lessonLocationLabel.font = [UIFont systemFontOfSize:kSmallLabelFontSize];
        [self addSubview:_lessonLocationLabel];
        
        _sectionLabel = [[UILabel alloc] init];
        _sectionLabel.textColor = [UIColor whiteColor];
        _sectionLabel.font = [UIFont systemFontOfSize:kSmallLabelFontSize];
        [self addSubview:_sectionLabel];
        
        _timeIconImageView = [[UIImageView alloc] init];
        _timeIconImageView.image = [UIImage imageNamed:@"icon_time"];
        [self addSubview:_timeIconImageView];
        
        [_lessonNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
        }];
        
        [_timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self.sectionLabel);
            make.width.height.equalTo(@(kIconSize));
        }];
        
        [_sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self.timeIconImageView.mas_right).with.offset(kContentInterval);
            make.top.equalTo(self.lessonNameLabel.mas_bottom).with.offset(kContentInterval);
        }];
        
        [_sectionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        [_lessonLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self);
            make.left.equalTo(self.sectionLabel.mas_right).with.offset(kContentInterval);
            make.top.equalTo(self.lessonNameLabel.mas_bottom).with.offset(kContentInterval);
        }];
    }
    return self;
}

#pragma mark - Setter / Getter

- (void)setLessonName:(NSString *)lessonName
{
    _lessonNameLabel.text = lessonName;
}

- (NSString *)lessonName
{
    return _lessonNameLabel.text;
}

- (void)setLessonLocation:(NSString *)lessonLocation
{
    _lessonLocationLabel.text = lessonLocation;
}

- (NSString *)lessonLocation
{
    return _lessonLocationLabel.text;
}

- (void)setSectionDescription:(NSString *)sectionDescription
{
    _sectionLabel.text = sectionDescription;
}

- (NSString *)sectionDescription
{
    return _sectionLabel.text;
}

@end
