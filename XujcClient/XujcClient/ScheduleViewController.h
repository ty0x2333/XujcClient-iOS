/**
 * @file ScheduleViewController.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "ScheduleViewModel.h"

@interface ScheduleViewController : UIViewController

- (instancetype)initWithViewModel:(ScheduleViewModel *)viewModel;

@end
