//
//  InputTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "InputTableViewCell.h"

static CGFloat const kInputLabelMarginHorizontal = 10.f;

@interface InputTableViewCell()

@property (nonatomic, strong) UILabel *inputLabel;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation InputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _inputLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_inputLabel];
        _textField = [[UITextField alloc] init];
        [self.contentView addSubview:_textField];
        [_inputLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(kInputLabelMarginHorizontal);
            make.top.bottom.equalTo(self.contentView);
            make.width.lessThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.5f);
        }];
        
        [_textField makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.contentView);
            make.left.equalTo(self.inputLabel.mas_right).with.offset(kInputLabelMarginHorizontal);
            make.width.greaterThanOrEqualTo(self.contentView.mas_width).multipliedBy(0.5f);
        }];
    }
    return self;
}

@end
