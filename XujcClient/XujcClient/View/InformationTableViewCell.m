//
//  InformationTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "InformationTableViewCell.h"

static const CGFloat kBorderWith = .5f;
static const CGFloat kCornerRadius = 4.f;

static const CGFloat kContentMarginHorizontal = 5.f;

@interface InformationTableViewCell()

@property (strong, nonatomic) UIView *informationDetailView;

@end

@implementation InformationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        self.contentView.layer.borderColor = [UIColor ty_border].CGColor;
        self.contentView.layer.borderWidth = kBorderWith;
        self.contentView.layer.cornerRadius = kCornerRadius;
        self.contentView.layer.masksToBounds = true;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).with.offset(kContentMarginHorizontal);
            make.trailing.equalTo(self).with.offset(-kContentMarginHorizontal);
        }];
    }
    return self;
}

- (UIView *)informationDetailView
{
    if (!_informationDetailView) {
        _informationDetailView = [[UIView alloc] init];
        _informationDetailView.backgroundColor = [UIColor ty_backgroundHighlight];
        [self.contentView addSubview:_informationDetailView];
        @weakify(self);
        [_informationDetailView makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(self.contentView);
            make.leading.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
    }
    return _informationDetailView;
}

@end
