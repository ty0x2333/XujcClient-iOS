//
//  TermTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TermTableViewCell.h"

@interface TermTableViewCell()

@end

@implementation TermTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setViewModel:(TermTableViewCellViewModel *)viewModel
{
    RAC(self.textLabel, text) = [RACObserve(viewModel.xujcTermModel, displayName) takeUntil:self.rac_prepareForReuseSignal];
}

@end
