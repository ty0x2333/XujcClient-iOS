/**
 * @file ScheduleColumnHeader.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/1
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "ScheduleColumnHeader.h"

static CGFloat const kDateTitleFontSize = 10.0f;
static CGFloat const kDayOfWeekTitleFontSize = 15.0f;
static CGFloat const kBackgroundCornerRadius = 10.0f;

@interface ScheduleColumnHeader ()

@property (nonatomic, strong) UILabel *dayOfWeekTitleLabel;
@property (nonatomic, strong) UILabel *dateTitleLabel;
@property (nonatomic, strong) UIView *titleBackground;

@end

@implementation ScheduleColumnHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor greenColor];
        
        _titleBackground = [UIView new];
        _titleBackground.layer.cornerRadius = kBackgroundCornerRadius;
        [self addSubview:_titleBackground];
        
        _dayOfWeekTitleLabel = [UILabel new];
        _dayOfWeekTitleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_dayOfWeekTitleLabel];
        
        _dateTitleLabel = [UILabel new];
        _dateTitleLabel.backgroundColor = [UIColor clearColor];
        _dateTitleLabel.font = [UIFont systemFontOfSize:kDateTitleFontSize];
        [self addSubview:_dateTitleLabel];
        
        [_dateTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dayOfWeekTitleLabel.bottom);
            make.centerX.equalTo(_dayOfWeekTitleLabel);
            make.bottom.equalTo(_titleBackground).offset(-4.0);
        }];
        
        [_dayOfWeekTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleBackground).offset(2.0);
            make.left.equalTo(_titleBackground).offset(12.0);
            make.right.equalTo(_titleBackground).offset(-12.0);
        }];
        
        [_titleBackground makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return self;
}

- (void)setDay:(NSDate *)day
{
    _day = day;
    
    static NSDateFormatter *dayOfWeekFormatter;
    static NSDateFormatter *dateFormatter;
    if (!dayOfWeekFormatter) {
        dayOfWeekFormatter = [NSDateFormatter new];
        dayOfWeekFormatter.dateFormat = @"EE";
    }
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MM-dd";
    }
    
    _dayOfWeekTitleLabel.text = [dayOfWeekFormatter stringFromDate:day];
    _dateTitleLabel.text = [dateFormatter stringFromDate:day];
    [self setNeedsLayout];
}

- (void)setIsCurrentDay:(BOOL)isCurrentDay
{
    _isCurrentDay = isCurrentDay;
    
    if (_isCurrentDay) {
        _dayOfWeekTitleLabel.textColor = [UIColor whiteColor];
        _dayOfWeekTitleLabel.font = [UIFont boldSystemFontOfSize:kDayOfWeekTitleFontSize];
        _dateTitleLabel.textColor = [UIColor whiteColor];
        _titleBackground.backgroundColor = [UIColor colorWithHexString:@"fd3935"];
    } else {
        _dayOfWeekTitleLabel.font = [UIFont systemFontOfSize:kDayOfWeekTitleFontSize];
        _dayOfWeekTitleLabel.textColor = [UIColor blackColor];
        _dateTitleLabel.textColor = [UIColor blackColor];
        _titleBackground.backgroundColor = [UIColor clearColor];
    }
}

@end
