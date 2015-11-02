/**
 * @file ScheduleRowHeader.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/1
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "ScheduleRowHeader.h"

@implementation ScheduleRowHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor redColor];
        self.title = [UILabel new];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:12.0];
        self.layer.borderWidth = 1.0f;
        [self addSubview:self.title];
        
        [self.title makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.right.equalTo(self.right).offset(-5.0);
        }];
    }
    return self;
}

#pragma mark - MSTimeRowHeader

- (void)setTime:(NSDate *)time
{
    _time = time;
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"H:mm";
    }
    self.title.text = [dateFormatter stringFromDate:time];
    [self setNeedsLayout];
}


@end
