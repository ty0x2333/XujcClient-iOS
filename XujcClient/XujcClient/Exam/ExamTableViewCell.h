//
//  ExamTableViewCell.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/18.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "InformationTableViewCell.h"
@class ExamTableViewCellViewModel;

@interface ExamTableViewCell : InformationTableViewCell

@property (strong, nonatomic) ExamTableViewCellViewModel *viewModel;

@end
