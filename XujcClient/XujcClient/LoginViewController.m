//
//  LoginViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/1.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+BorderLine.h"
#import "LoginLayoutConfigs.h"

@interface LoginViewController()

@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) UIButton *switchButton;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.ty_borderColor = [UIColor blackColor].CGColor;
    _accountTextField.ty_borderEdge = UIRectEdgeBottom;
    _accountTextField.placeholder = NSLocalizedString(@"EmailOrPhone", nil);
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_accountTextField];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.ty_borderColor = [UIColor blackColor].CGColor;
    _passwordTextField.ty_borderEdge = UIRectEdgeBottom;
    _passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passwordTextField];
    
    _okButton = [[UIButton alloc] init];
    _okButton.backgroundColor = [UIColor blueColor];
    [_okButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    _okButton.layer.cornerRadius = kLoginLayoutButtonRadius;
    [self.view addSubview:_okButton];
    
    _switchButton = [[UIButton alloc] init];
    [_switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_switchButton setTitle:NSLocalizedString(@"SwitchToSign", nil) forState:UIControlStateNormal];
    [self.view addSubview:_switchButton];
    
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_left).with.offset(kLoginContentMarginHorizontal);
        make.right.equalTo(self.view.mas_right).with.offset(-kLoginContentMarginHorizontal);
    }];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountTextField.mas_bottom);
        make.leading.equalTo(_accountTextField);
        make.trailing.equalTo(_accountTextField);
    }];
    
    [_okButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom);
        make.leading.equalTo(_accountTextField);
        make.trailing.equalTo(_accountTextField);
        make.height.equalTo(@(kLoginButtonHeight));
    }];
    
    [_switchButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_okButton.mas_bottom);
        make.centerX.equalTo(_okButton.mas_centerX);
    }];
}

@end
