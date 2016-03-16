//
//  SemesterTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterTableViewCell.h"

@interface SemesterTableViewCell()

@end

@implementation SemesterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setViewModel:(SemesterTableViewCellViewModel *)viewModel
{
    RAC(self.textLabel, text) = [RACObserve(viewModel.semesterModel, displayName) takeUntil:self.rac_prepareForReuseSignal];
}

@end
