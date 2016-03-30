//
//  VerificationCodeTextField.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/30.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "VerificationCodeTextField.h"
#import "UIView+BorderLine.h"

static CGFloat const kVerificationButtonWidth = 100.f;
static CGFloat const kVerificationButtonHeight = 34.f;

@interface VerificationCodeTextField()

@property (strong, nonatomic) UIButton *button;

@end

@implementation VerificationCodeTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.ty_borderColor = [UIColor ty_border].CGColor;
        self.ty_borderEdge = UIRectEdgeBottom;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.placeholder = NSLocalizedString(@"Verification Code", nil);
        
        _button = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(kVerificationButtonWidth, kVerificationButtonHeight)}];
        _button.layer.borderWidth = .5f;
        _button.layer.cornerRadius = 4.f;
        _button.layer.borderColor = [UIColor ty_border].CGColor;
        _button.titleLabel.font = self.font;
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [_button setTitle:NSLocalizedString(@"Get Code", nil) forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor ty_textBlack] forState:UIControlStateNormal];
        self.rightView = _button;
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end
