//
//  TTTAttributedLabel+Theme.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TTTAttributedLabel+Theme.h"

static CGFloat const kSmallLabelFontSize = 12.f;

@implementation TTTAttributedLabel (Theme)

+ (TTTAttributedLabel *)ty_smallLabel
{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor ty_textGray];
    label.font = [UIFont systemFontOfSize:kSmallLabelFontSize];
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    label.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName: [NSNumber numberWithBool:NO], (NSString*)kCTForegroundColorAttributeName: (id)[UIColor ty_textLink].CGColor};
    return label;
}

@end
