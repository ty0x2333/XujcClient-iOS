//
//  SemesterTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterTableViewCell.h"
#import "TextIconView.h"

static CGFloat const kCurrentTextIconMarginRight = 5.f;

@interface SemesterTableViewCell()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) TextIconView *currentTextIcon;

@end

@implementation SemesterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
        
        _currentTextIcon = [[TextIconView alloc] init];
        _currentTextIcon.text = NSLocalizedString(@"Current Semester", nil);
        [self addSubview:_currentTextIcon];

        [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        [_currentTextIcon makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.nameLabel.mas_left).with.offset(-kCurrentTextIconMarginRight);
            make.centerY.equalTo(self.nameLabel);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RAC(self, backgroundColor) = [RACObserve(self, selected) map:^id(NSNumber *value) {
            return [value boolValue] ? [UIColor ty_backgroundHighlight] : [UIColor clearColor];
        }];
    }
    return self;
}

- (void)setViewModel:(SemesterTableViewCellViewModel *)viewModel
{
    RAC(self.nameLabel, text) = [RACObserve(viewModel.semesterModel, displayName) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.currentTextIcon, hidden) = [RACObserve(viewModel, isCurrent) not];
}

@end
