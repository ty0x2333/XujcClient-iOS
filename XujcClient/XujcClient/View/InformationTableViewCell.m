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
    }
    return self;
}


@end
