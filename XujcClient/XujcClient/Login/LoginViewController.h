//
//  LoginViewController.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/1.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewModel.h"
#import "SignupViewModel.h"

@interface LoginViewController : BaseViewController

- (instancetype)initWithLoginViewModel:(LoginViewModel *)loginViewModel andSignupViewModel:(SignupViewModel *)signupViewModel;

@end
