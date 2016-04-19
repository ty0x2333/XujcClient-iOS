//
//  ScoreTableViewCellViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreTableViewCellViewModel.h"

@interface ScoreTableViewCellViewModel()

@property (strong, nonatomic) XujcScoreModel *xujcScoreModel;

@end

@implementation ScoreTableViewCellViewModel

- (instancetype)initWithModel:(XujcScoreModel *)xujcScoreModel
{
    if (self = [super init]) {
        _xujcScoreModel = xujcScoreModel;
        RACChannelTo(self, lessonName) = RACChannelTo(self, xujcScoreModel.lessonName);
        RACChannelTo(self, score) = RACChannelTo(self, xujcScoreModel.score);
        RACChannelTo(self, studyWay) = RACChannelTo(self, xujcScoreModel.studyWay);
        RACChannelTo(self, credit) = RACChannelTo(self, xujcScoreModel.credit);
    }
    return self;
}

@end
