/**
 * @file CourseEventCell.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "XujcCourseEvent.h"

@interface CourseEventCell : UICollectionViewCell

@property (nonatomic, weak) XujcCourseEvent *event;

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *location;

@end
