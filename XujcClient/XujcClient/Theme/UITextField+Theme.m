//
//  UITextField+Theme.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UITextField+Theme.h"
#import "UIView+BorderLine.h"

@implementation UITextField (Theme)

+ (UITextField *)ty_textField
{
    UITextField *textField = [[UITextField alloc] init];
    textField.ty_borderColor = [UIColor ty_border].CGColor;
    textField.ty_borderEdge = UIRectEdgeBottom;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    return textField;
}

@end
