//
//  ScoreTableViewCellViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XujcScoreModel.h"

@interface ScoreTableViewCellViewModel : NSObject

- (instancetype)initWithModel:(XujcScoreModel *)xujcScoreModel;

@property (nonatomic, readonly, copy) NSString *lessonName;

@property (nonatomic, readonly, assign) NSInteger score;

@property (nonatomic, readonly, copy) NSString *studyWay;

@property (nonatomic, readonly, assign) NSInteger credit;


@end
