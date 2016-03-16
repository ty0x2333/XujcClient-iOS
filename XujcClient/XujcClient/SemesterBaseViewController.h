//
//  SemesterBaseViewController.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LMDropdownView.h>
#import "SemesterBaseViewModel.h"

@interface SemesterBaseViewController : UIViewController

- (instancetype)initWithViewModel:(SemesterBaseViewModel *)viewModel;

@property (strong, readonly, nonatomic) UIButton *semesterButton;

@property (strong, readonly, nonatomic) LMDropdownView *dropdownView;

@end
