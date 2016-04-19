//
//  ExamTableViewCellViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/19.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ExamTableViewCellViewModel.h"
#import "XujcExamModel.h"

@interface ExamTableViewCellViewModel()

@property (nonatomic, strong) XujcExamModel *model;

@end

@implementation ExamTableViewCellViewModel

- (instancetype)initWithModel:(XujcExamModel *)model
{
    if (self = [super init]) {
        _model = model;
        RACChannelTo(self, lessonName) = RACChannelTo(self, model.lessonName);
        RACChannelTo(self, location) = RACChannelTo(self, model.location);
        
        RAC(self, dateDescription) = [RACSignal combineLatest:@[RACChannelTo(self, model.startDate), RACChannelTo(self, model.time), RACChannelTo(self, model.week)] reduce:^id(NSString *date, NSString *time){
            return [NSString stringWithFormat:@"%@ %@", date, time];
        }];
        
        RAC(self, weekDescription) = [RACSignal combineLatest:@[RACChannelTo(self, model.week), RACChannelTo(self, model.timePeriod)] reduce:^id(NSString *week, NSString *timePeriod){
            return [NSString stringWithFormat:@"%@ %@ %@", NSLocalizedString(@"Week", nil), week, timePeriod];
        }];
        RACChannelTo(self, way) = RACChannelTo(self, model.way);
        RACChannelTo(self, name) = RACChannelTo(self, model.name);
        RACChannelTo(self, status) = RACChannelTo(self, model.status);
    }
    return self;
}

@end
