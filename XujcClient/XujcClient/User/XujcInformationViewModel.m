//
//  XujcInformationViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "XujcInformationViewModel.h"
#import "XujcUserModel.h"

@interface XujcInformationViewModel()

@property (strong, nonatomic) XujcUserModel *model;

@end

@implementation XujcInformationViewModel

- (instancetype)initWithModel:(XujcUserModel *)model
{
    if (self = [super init]) {
        _model = model;
        RACChannelTo(self, studentId) = RACChannelTo(model, studentId);
        RACChannelTo(self, name) = RACChannelTo(model, name);
        RAC(self, grade) = [RACObserve(model, grade) map:^id(id value) {
            return [NSString stringWithFormat:@"%@", value];
        }];
        RACChannelTo(self, major) = RACChannelTo(model, major);
    }
    return self;
}

@end
