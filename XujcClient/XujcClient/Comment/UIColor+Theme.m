//
//  UIColor+Theme.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/27.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UIColor+Theme.h"

@implementation UIColor (Theme)

+ (UIColor *)ty_textGreen
{
    return [UIColor colorWithHexString:@"#73c990"];
}

+ (UIColor *)ty_textRed
{
    return [UIColor colorWithHexString:@"#ff6347"];
}

+ (UIColor *)ty_textBlack
{
    return [UIColor colorWithHexString:@"#424243"];
}

+ (UIColor *)ty_textDisable
{
    return [UIColor ty_border];
}

+ (UIColor *)ty_backgroundHighlight
{
    return [UIColor colorWithHexString:@"#f5f5f5"];
}

+ (UIColor *)ty_border
{
    return [UIColor colorWithRed:0 green:0 blue:0.1f alpha:0.22f];
}

+ (UIColor *)ty_buttonBackground
{
    return [UIColor colorWithHexString:@"#2e9dff"];
}

+ (UIColor *)ty_buttonDisableBackground
{
    return [UIColor colorWithHexString:@"#b8d8f3"];
}

@end
