/**
 * @file CourseEventCell.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "CourseEventViewModel.h"

@interface CourseEventCell : UICollectionViewCell

@property (strong, nonatomic) CourseEventViewModel *viewModel;

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *location;

@end
