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
        RACChannelTo(self, startData) = RACChannelTo(self, model.startData);
        RACChannelTo(self, timePeriod) = RACChannelTo(self, model.timePeriod);
        RACChannelTo(self, time) = RACChannelTo(self, model.time);
        RACChannelTo(self, way) = RACChannelTo(self, model.way);
        RACChannelTo(self, week) = RACChannelTo(self, model.week);
        RACChannelTo(self, name) = RACChannelTo(self, model.name);
        RACChannelTo(self, status) = RACChannelTo(self, model.status);
    }
    return self;
}

@end
