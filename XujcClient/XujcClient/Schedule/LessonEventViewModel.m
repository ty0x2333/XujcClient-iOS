//
//  LessonEventViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LessonEventViewModel.h"
#import "XujcLessonEventModel.h"

@interface LessonEventViewModel()

@property (nonatomic, strong) XujcLessonEventModel *model;

@end

@implementation LessonEventViewModel

- (instancetype)initWithModel:(XujcLessonEventModel *)model
{
    if (self = [super init]) {
        _model = model;
        RACChannelTo(self, name) = RACChannelTo(model, name);
        RACChannelTo(self, location) = RACChannelTo(model, location);
    }
    return self;
}

@end
