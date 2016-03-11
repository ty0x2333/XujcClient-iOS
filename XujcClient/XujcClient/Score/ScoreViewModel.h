//
//  ScoreViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreTableViewCellViewModel.h"

@interface ScoreViewModel : NSObject

- (ScoreTableViewCellViewModel *)scoreTableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
