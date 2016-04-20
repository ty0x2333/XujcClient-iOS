//
//  LessonEventPopViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LessonEventPopViewModel.h"
#import "XujcLessonEventModel.h"

@implementation LessonEventPopViewModel

- (instancetype)initWithModel:(XujcLessonEventModel *)model
{
    if (self = [super initWithModel:model]) {
        RACChannelTo(self, weekInterval) = RACChannelTo(model, weekInterval);
        RAC(self, startEndWeek) = [RACSignal combineLatest:@[RACObserve(model, startWeek), RACObserve(model, endWeek)]
                                                 reduce:^id(NSNumber *start, NSNumber *end){
                                                     return [NSString stringWithFormat:NSLocalizedString(@"%zd-%zd Week", nil), [start integerValue], [end integerValue]];
                                                 }];
    }
    return self;
}

@end
