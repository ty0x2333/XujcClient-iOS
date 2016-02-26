//
//  ScoreTableViewCell.m
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreTableViewCell.h"
#import <ReactiveCocoa.h>

@implementation ScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        RACSignal *scoreSignal = RACObserve(self, score);
        RAC(self.detailTextLabel, text) = [scoreSignal map:^id(NSNumber *value) {
            return [value stringValue];
        }];
        
        RAC(self.detailTextLabel, textColor) = [scoreSignal map:^id(NSNumber *value) {
            return [value integerValue] > 59 ? [UIColor greenColor] : [UIColor redColor];
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end