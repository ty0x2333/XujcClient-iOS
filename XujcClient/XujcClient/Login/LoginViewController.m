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
#import <ReactiveCocoa.h>

@interface LoginViewController()

@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) UITextField *signupNicknameTextField;
@property (strong, nonatomic) UITextField *signupEmailTextField;
@property (strong, nonatomic) UITextField *signupPasswordTextField;

@property (strong, nonatomic) UIButton *switchButton;

@property (strong, nonatomic) MASConstraint *accountTextFieldRightConstraint;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_logoImageView];
    
    _accountTextField = [self p_textFieldMaker];
    _accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _accountTextField.placeholder = NSLocalizedString(@"EmailOrPhone", nil);
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_accountTextField];
    
    _passwordTextField = [self p_textFieldMaker];
    _passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_passwordTextField];
    
    _signupNicknameTextField = [self p_textFieldMaker];
    _signupNicknameTextField.placeholder = NSLocalizedString(@"Nickname", nil);
    _signupNicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_signupNicknameTextField];
    
    _signupEmailTextField = [self p_textFieldMaker];
    _signupEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _signupEmailTextField.placeholder = NSLocalizedString(@"Email", nil);
    _signupEmailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_signupEmailTextField];
    
    _signupPasswordTextField = [self p_textFieldMaker];
    _signupPasswordTextField.placeholder = NSLocalizedString(@"Password", nil);
    _signupPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_signupPasswordTextField];
    
    _okButton = [[UIButton alloc] init];
    _okButton.backgroundColor = [UIColor blueColor];
    _okButton.layer.cornerRadius = kLoginLayoutButtonRadius;
    [self.view addSubview:_okButton];
    
    _switchButton = [[UIButton alloc] init];
    [_switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_switchButton];
    
    [self initConstraints];
    
    @weakify(self);
    
    RACSignal *switchButtonStatusChangedSignal = RACObserve(_switchButton, selected);
    [switchButtonStatusChangedSignal subscribeNext:^(NSNumber *value) {
        @strongify(self);
        BOOL selected = [value boolValue];
        [self.accountTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.accountTextFieldRightConstraint uninstall];
            if (selected) {
                self.accountTextFieldRightConstraint = make.right.equalTo(self.view.mas_left).with.offset(-kLoginContentMarginHorizontal);
            } else {
                self.accountTextFieldRightConstraint = make.right.equalTo(self.view.mas_right).with.offset(-kLoginContentMarginHorizontal);
            }
        }];
        [UIView animateWithDuration:.5f animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }];
    
    [_switchButton rac_liftSelector:@selector(setTitle:forState:) withSignals:[switchButtonStatusChangedSignal map:^id(NSNumber *value) {
        return [value boolValue] ? NSLocalizedString(@"SwitchToLogin", nil) : NSLocalizedString(@"SwitchToSignup", nil);
    }], [RACSignal return:@(UIControlStateNormal)], nil];
    
    [_okButton rac_liftSelector:@selector(setTitle:forState:) withSignals:[switchButtonStatusChangedSignal map:^id(NSNumber *value) {
        return ![value boolValue] ? NSLocalizedString(@"Login", nil) : NSLocalizedString(@"Signup", nil);
    }], [RACSignal return:@(UIControlStateNormal)], nil];
    
    _switchButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        TyLogDebug(@"switch button clicked");
        self.switchButton.selected = !self.switchButton.selected;
        return [RACSignal empty];
    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void)initConstraints
{
    [_logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.5f);
        make.width.equalTo(_logoImageView.mas_height);
    }];
    
    [_signupNicknameTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_bottom);
        make.left.equalTo(_accountTextField.mas_right).with.offset(2 * kLoginContentMarginHorizontal);
        make.width.equalTo(self.view.mas_width).with.offset(-2 * kLoginContentMarginHorizontal);
        make.height.equalTo(@(kLoginTextFieldHeight));
    }];
    
    [_signupEmailTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_signupNicknameTextField.mas_bottom);
        make.left.equalTo(_signupNicknameTextField);
        make.width.equalTo(_signupNicknameTextField);
        make.height.equalTo(_signupNicknameTextField);
    }];
    
    [_signupPasswordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_signupEmailTextField.mas_bottom);
        make.left.equalTo(_signupNicknameTextField);
        make.width.equalTo(_signupNicknameTextField);
        make.height.equalTo(_signupNicknameTextField);
    }];
    
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_signupEmailTextField);
        self.accountTextFieldRightConstraint = make.right.equalTo(self.view.mas_right).with.offset(-kLoginContentMarginHorizontal);
        make.width.equalTo(_signupNicknameTextField);
        make.height.equalTo(@(kLoginTextFieldHeight));
    }];
    [_passwordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountTextField.mas_bottom);
        make.leading.equalTo(_accountTextField);
        make.trailing.equalTo(_accountTextField);
        make.height.equalTo(_accountTextField);
    }];
    
    [_okButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).with.offset(kLoginButtonMarginTop);
        make.width.equalTo(_signupNicknameTextField);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(kLoginButtonHeight));
    }];
    
    [_switchButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_okButton.mas_bottom);
        make.centerX.equalTo(_okButton.mas_centerX);
    }];
}

#pragma mark - Event Response

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Helper

- (UITextField *)p_textFieldMaker
{
    UITextField *textField = [[UITextField alloc] init];
    textField.ty_borderColor = [UIColor ty_border].CGColor;
    textField.ty_borderEdge = UIRectEdgeBottom;
    return textField;
}

@end
