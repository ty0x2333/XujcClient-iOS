//
//  TodayEventTableViewCellViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TodayEventTableViewCellViewModel.h"
#import "XujcLessonEventModel.h"
#import "XujcSection.h"
#import <ReactiveCocoa.h>

@interface TodayEventTableViewCellViewModel()

@property (nonatomic, strong) XujcLessonEventModel *model;

@end

@implementation TodayEventTableViewCellViewModel

- (instancetype)initWithModel:(XujcLessonEventModel *)model
{
    if (self = [super init]) {
        _model = model;
        RACChannelTo(self, lessonName) = RACChannelTo(_model, name);
        RACChannelTo(self, lessonLocation) = RACChannelTo(_model, location);
        RAC(self, sectionDescription) = [RACSignal combineLatest:@[RACObserve(self.model, startSection), RACObserve(self.model, endSection)] reduce:^id(XujcSection *start, XujcSection *end) {
            return [NSString stringWithFormat:@"%@-%@节", [start displayName], [end displayName]];
        }];
        RAC(self, weekDescription) = [RACSignal combineLatest:@[RACObserve(self.model, startWeek), RACObserve(self.model, endWeek), RACObserve(self.model, weekInterval)] reduce:^id(NSNumber *start, NSNumber *end, NSString *interval) {
            return [NSString stringWithFormat:@"%zd-%zd周 %@", [start integerValue], [end integerValue], interval];
        }];
    }
    return self;
}

@end
