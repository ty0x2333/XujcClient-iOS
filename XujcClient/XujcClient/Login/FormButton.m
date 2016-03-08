//
//  FormButton.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/9.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "FormButton.h"

static const CGFloat kFormButtonRadius = 4.f;

@implementation FormButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor ty_buttonBackground];
        self.layer.cornerRadius = kFormButtonRadius;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    self.backgroundColor = enabled ? [UIColor ty_buttonBackground] : [UIColor ty_buttonDisableBackground];
}

@end
