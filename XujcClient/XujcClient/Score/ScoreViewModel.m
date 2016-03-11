//
//  ScoreViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScoreViewModel.h"
#import "XujcScore.h"

@interface ScoreViewModel()

@property (strong, nonatomic) NSArray<XujcScore *> *scores;

@end

@implementation ScoreViewModel

- (ScoreTableViewCellViewModel *)scoreTableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning test
    return nil;
}

@end
