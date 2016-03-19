/**
 * @file LessonEventCell.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "LessonEventViewModel.h"

@interface LessonEventCell : UICollectionViewCell

@property (strong, nonatomic) LessonEventViewModel *viewModel;

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *location;

@end
