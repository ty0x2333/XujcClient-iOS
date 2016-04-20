//
//  ScheduleTheme.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScheduleTheme.h"

@implementation ScheduleTheme

+ (UIColor *)textColorHighlighted:(BOOL)selected
{
    return selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"21729c"];
}

+ (UIColor *)backgroundColorHighlighted:(BOOL)selected
{
    return selected ? [UIColor colorWithHexString:@"35b1f1"] : [[UIColor colorWithHexString:@"35b1f1"] colorWithAlphaComponent:0.2];
}

@end
