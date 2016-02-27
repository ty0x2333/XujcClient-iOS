//
//  ScoreTableViewCell.h
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XujcScore;

@interface ScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) XujcScore *xujcScoreModel;

@property (assign, nonatomic) BOOL detailHidden;

@end
