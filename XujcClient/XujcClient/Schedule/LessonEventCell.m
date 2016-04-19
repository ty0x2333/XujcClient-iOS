/**
 * @file LessonEventCell.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "LessonEventCell.h"
#import "ScheduleTheme.h"

static CGFloat const kFontSize = 12.f;

@interface LessonEventCell()

@property (nonatomic, strong) UIView *borderView;

@end

@implementation LessonEventCell

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.layer.shouldRasterize = YES;
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0.0, 4.0);
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOpacity = 0.0;
        
        self.borderView = [UIView new];
        self.borderView.backgroundColor = [self borderColor];
        [self.contentView addSubview:self.borderView];
        
        self.title = [UILabel new];
        self.title.font = [UIFont systemFontOfSize:kFontSize];
        self.title.numberOfLines = 0;
        self.title.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.title];
        
        self.location = [UILabel new];
        self.location.font = [UIFont systemFontOfSize:kFontSize];
        self.location.numberOfLines = 0;
        self.location.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.location];
        
        CGFloat borderWidth = 2.0;
        CGFloat contentMargin = 2.0;
        UIEdgeInsets contentPadding = UIEdgeInsetsMake(1.0, (borderWidth + 4.0), 1.0, 4.0);
        
        [self.borderView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.height);
            make.width.equalTo(@(borderWidth));
            make.left.equalTo(self.left);
            make.top.equalTo(self.top);
        }];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(contentPadding.top);
            make.left.equalTo(self.left).offset(contentPadding.left);
            make.right.equalTo(self.right).offset(-contentPadding.right);
        }];
        
        [self.location makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.bottom).offset(contentMargin);
            make.left.equalTo(self.left).offset(contentPadding.left);
            make.right.equalTo(self.right).offset(-contentPadding.right);
            make.bottom.lessThanOrEqualTo(self.bottom).offset(-contentPadding.bottom);
        }];
        
        RACSignal *selectedSignal = RACObserve(self, selected);
        
        [selectedSignal subscribeNext:^(NSNumber *value) {
            BOOL isSelected = [value boolValue];
            self.contentView.backgroundColor = [ScheduleTheme backgroundColorHighlighted:isSelected];
            
            UIColor *textColor = [ScheduleTheme textColorHighlighted:isSelected];
            
            self.title.textColor = textColor;
            self.location.textColor = textColor;
            
            if (isSelected) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.transform = CGAffineTransformMakeScale(1.025, 1.025);
                    self.layer.shadowOpacity = 0.2;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        self.transform = CGAffineTransformIdentity;
                    }];
                }];
            } else {
                self.layer.shadowOpacity = 0;
            }
        }];

    }
    return self;
}

#pragma mark - MSEventCell

- (void)setViewModel:(LessonEventViewModel *)viewModel
{
    if (_viewModel == viewModel) {
        return;
    }
    _viewModel = viewModel;
    
    RAC(self.title, text) = [RACObserve(_viewModel, name) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.location, text) = [RACObserve(_viewModel, location) takeUntil:self.rac_prepareForReuseSignal];
}

- (UIColor *)borderColor
{
    return [[ScheduleTheme backgroundColorHighlighted:NO] colorWithAlphaComponent:1.0];
}


@end
