//
//  TermBaseViewController.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LMDropdownView.h>
#import "TermBaseViewModel.h"

@interface TermBaseViewController : UIViewController

- (instancetype)initWithViewModel:(TermBaseViewModel *)viewModel;

@property (strong, readonly, nonatomic) UIButton *termButton;

@property (strong, readonly, nonatomic) LMDropdownView *dropdownView;

@end
