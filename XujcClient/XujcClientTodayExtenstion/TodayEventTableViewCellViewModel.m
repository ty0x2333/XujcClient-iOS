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
        RAC(self, sectionDescription) = [RACSignal combineLatest:@[RACObserve(_model, startSection), RACObserve(_model, endSection)] reduce:^id(XujcSection *start, XujcSection *end) {
            return [NSString stringWithFormat:@"%@-%@节", [start displayName], [end displayName]];
        }];
    }
    return self;
}

@end
