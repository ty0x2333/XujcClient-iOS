/**
 * @file ScheduleRowHeader.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/1
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "ScheduleRowHeader.h"

static CGFloat const kTimeTitleFontSize = 12.0f;
static CGFloat const kClassSectionNumberTitleFontSize = 16.0f;

@implementation ScheduleRowHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor redColor];
        _timeTitle = [UILabel new];
        _timeTitle.backgroundColor = [UIColor clearColor];
        _timeTitle.font = [UIFont systemFontOfSize:kTimeTitleFontSize];
//        self.layer.borderWidth = 1.0f;
        [self addSubview:_timeTitle];
        
        _classSectionNumberTitle = [UILabel new];
        _classSectionNumberTitle.backgroundColor = [UIColor clearColor];
        _classSectionNumberTitle.font = [UIFont systemFontOfSize:kClassSectionNumberTitleFontSize];
        [self addSubview:_classSectionNumberTitle];
        
        [_classSectionNumberTitle makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerY);
            make.centerX.equalTo(self.centerX);
        }];
        
        [_timeTitle makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.centerY);
            make.centerX.equalTo(self.centerX);
        }];
    }
    return self;
}

#pragma mark - MSTimeRowHeader

- (void)setClassSection:(XujcSection *)classSection
{
    _classSection = classSection;
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"H:mm";
    }
    _timeTitle.text = [dateFormatter stringFromDate:_classSection.startTime];
    
    NSInteger sectionNumber = _classSection.sectionNumber;
    if (sectionNumber == 51){
        _classSectionNumberTitle.text = @"午1";
    }else if (sectionNumber == 52){
        _classSectionNumberTitle.text = @"午2";
    }else{
        _classSectionNumberTitle.text = [NSString stringWithFormat:@"%ld", _classSection.sectionNumber];
    }
    [self setNeedsLayout];
}

@end
