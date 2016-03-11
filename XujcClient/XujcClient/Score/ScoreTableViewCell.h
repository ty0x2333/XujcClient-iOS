//
//  ScoreTableViewCell.h
//  XujcClient
//
//  Created by 田奕焰 on 16/2/26.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreTableViewCellViewModel.h"

@interface ScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) ScoreTableViewCellViewModel *viewModel;

@property (assign, nonatomic) BOOL detailHidden;

@end
