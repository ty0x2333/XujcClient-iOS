//
//  SemesterBaseViewController.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <LMDropdownView.h>
#import "SemesterBaseViewModel.h"
#import "BaseViewController.h"

@interface SemesterBaseViewController : BaseViewController

- (instancetype)initWithViewModel:(SemesterBaseViewModel *)viewModel;

@property (strong, readonly, nonatomic) UIButton *semesterButton;

@property (strong, readonly, nonatomic) UILabel *semesterLabel;

@property (strong, readonly, nonatomic) LMDropdownView *dropdownView;

@end
