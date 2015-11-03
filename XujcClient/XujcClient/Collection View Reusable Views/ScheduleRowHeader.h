/**
 * @file ScheduleRowHeader.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/1
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "XujcSection.h"

@interface ScheduleRowHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) XujcSection *classSection;

@end
