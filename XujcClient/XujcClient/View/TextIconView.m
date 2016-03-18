//
//  TextIconView.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/19.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TextIconView.h"

static CGFloat const kCornerRadius = 3.f;
static CGFloat const kDefaultTextEdgeInsetsValue = 3.f;
static CGFloat const kTextLabelFontSize = 8.f;

@interface TextIconView()

@property (strong, nonatomic) UILabel *textLabel;

@property (assign, nonatomic) UIEdgeInsets textEdgeInsets;

@end

@implementation TextIconView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = kCornerRadius;
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:kTextLabelFontSize];
        [self addSubview:_textLabel];
        _textEdgeInsets = UIEdgeInsetsMake(kDefaultTextEdgeInsetsValue, kDefaultTextEdgeInsetsValue, kDefaultTextEdgeInsetsValue, kDefaultTextEdgeInsetsValue);
        self.backgroundColor = [UIColor ty_textGreen];
        [_textLabel makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(self.textEdgeInsets);
        }];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
}

- (NSString *)text
{
    return self.textLabel.text;
}

@end
