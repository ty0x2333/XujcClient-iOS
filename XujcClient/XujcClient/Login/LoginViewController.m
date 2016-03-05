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
#import "LoginTextFieldGroupView.h"

#import "LoginViewModel.h"

@interface LoginViewController()

@property (strong, nonatomic) LoginTextFieldGroupView *loginTextFieldGroupView;
@property (strong, nonatomic) LoginTextFieldGroupView *signupTextFieldGroupView;

@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UIButton *loginButton;

@property (strong, nonatomic) UITextField *signupNicknameTextField;
@property (strong, nonatomic) UITextField *signupEmailTextField;
@property (strong, nonatomic) UITextField *signupPasswordTextField;
@property (strong, nonatomic) UIButton *signupButton;

@property (strong, nonatomic) UIButton *switchButton;

@property (strong, nonatomic) MASConstraint *loginTextFieldGroupViewRightConstraint;

@property (strong, nonatomic) LoginViewModel *viewModel;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_logoImageView];
    
    _loginTextFieldGroupView = [[LoginTextFieldGroupView alloc] initWithItemHeight:kLoginTextFieldHeight];
    [self.view addSubview:_loginTextFieldGroupView];
    
    _accountTextField = [self p_textFieldMaker];
    _accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _accountTextField.placeholder = NSLocalizedString(@"EmailOrPhone", nil);
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_loginTextFieldGroupView addSubview:_accountTextField];
    
    _passwordTextField = [self p_textFieldMaker];
    _passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_loginTextFieldGroupView addSubview:_passwordTextField];
    
    _signupTextFieldGroupView = [[LoginTextFieldGroupView alloc] initWithItemHeight:kLoginTextFieldHeight];
    [self.view addSubview:_signupTextFieldGroupView];
    
    _signupNicknameTextField = [self p_textFieldMaker];
    _signupNicknameTextField.placeholder = NSLocalizedString(@"Nickname", nil);
    _signupNicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_signupTextFieldGroupView addSubview:_signupNicknameTextField];
    
    _signupEmailTextField = [self p_textFieldMaker];
    _signupEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _signupEmailTextField.placeholder = NSLocalizedString(@"Email", nil);
    _signupEmailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_signupTextFieldGroupView addSubview:_signupEmailTextField];
    
    _signupPasswordTextField = [self p_textFieldMaker];
    _signupPasswordTextField.placeholder = NSLocalizedString(@"Password", nil);
    _signupPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_signupTextFieldGroupView addSubview:_signupPasswordTextField];
    
    _loginButton = [[UIButton alloc] init];
    [_loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor ty_buttonBackground];
    _loginButton.layer.cornerRadius = kLoginLayoutButtonRadius;
    [self.view addSubview:_loginButton];
    
    _signupButton = [[UIButton alloc] init];
    [_signupButton setTitle:NSLocalizedString(@"Signup", nil) forState:UIControlStateNormal];
    _signupButton.backgroundColor = [UIColor ty_buttonBackground];
    _signupButton.layer.cornerRadius = kLoginLayoutButtonRadius;
    [self.view addSubview:_signupButton];
    
    _switchButton = [[UIButton alloc] init];
    [_switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_switchButton];
    
    [self initConstraints];
#warning test viewModel
    _viewModel = [[LoginViewModel alloc] init];
    
    // Binding
    @weakify(self);
    [self bindSwitchAnimation];
    
    [[[RACObserve(self.loginButton, enabled) distinctUntilChanged] map:^id(NSNumber *value) {
        return [value boolValue] ? [UIColor ty_buttonBackground] : [UIColor ty_buttonDisableBackground];
    }] subscribeNext:^(UIColor *color) {
        @strongify(self);
        self.loginButton.backgroundColor = color;
    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    
    [self bindViewModel];
}

- (void)initConstraints
{
    [_logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.5f);
        make.width.equalTo(_logoImageView.mas_height);
    }];
    
    [_signupTextFieldGroupView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_bottom);
        make.left.equalTo(_loginTextFieldGroupView.mas_right).with.offset(2 * kLoginContentMarginHorizontal);
        make.width.equalTo(self.view.mas_width).with.offset(-2 * kLoginContentMarginHorizontal);
    }];
    
    [_loginTextFieldGroupView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_signupEmailTextField);
        self.loginTextFieldGroupViewRightConstraint = make.right.equalTo(self.view.mas_right).with.offset(-kLoginContentMarginHorizontal);
        make.width.equalTo(_signupTextFieldGroupView);
    }];
    
    [_loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTextField.mas_bottom).with.offset(kLoginButtonMarginTop);
        make.width.equalTo(_signupNicknameTextField);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(kLoginButtonHeight));
    }];
    
    [_signupButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton);
        make.width.equalTo(_loginButton);
        make.centerX.equalTo(_loginButton);
        make.height.equalTo(_loginButton);
    }];
    
    [_switchButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginButton.mas_bottom);
        make.centerX.equalTo(_loginButton.mas_centerX);
    }];
}

- (void)bindSwitchAnimation
{
    @weakify(self);
    // Animate
    RACSignal *switchButtonStatusChangedSignal = [RACObserve(_switchButton, selected) distinctUntilChanged];
    [switchButtonStatusChangedSignal subscribeNext:^(NSNumber *value) {
        @strongify(self);
        BOOL selected = [value boolValue];
        [self.loginTextFieldGroupView mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.loginTextFieldGroupViewRightConstraint uninstall];
            if (selected) {
                self.loginTextFieldGroupViewRightConstraint = make.right.equalTo(self.view.mas_left).with.offset(-kLoginContentMarginHorizontal);
            } else {
                self.loginTextFieldGroupViewRightConstraint = make.right.equalTo(self.view.mas_right).with.offset(-kLoginContentMarginHorizontal);
            }
        }];
        [UIView animateWithDuration:.5f animations:^{
            [self.view layoutIfNeeded];
        }];
    }];
    // Text update
    [_switchButton rac_liftSelector:@selector(setTitle:forState:) withSignals:[switchButtonStatusChangedSignal map:^id(NSNumber *value) {
        return [value boolValue] ? NSLocalizedString(@"SwitchToLogin", nil) : NSLocalizedString(@"SwitchToSignup", nil);
    }], [RACSignal return:@(UIControlStateNormal)], nil];
    
    // Button Hidden
    RAC(_loginButton, hidden) = switchButtonStatusChangedSignal;
    RAC(_signupButton, hidden) = [RACObserve(_loginButton, hidden) not];
    
    // Selected change
    _switchButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        TyLogDebug(@"switch button clicked");
        self.switchButton.selected = !self.switchButton.selected;
        return [RACSignal empty];
    }];
}

- (void)bindViewModel
{
    _loginButton.rac_command = self.viewModel.executeLogin;
    RAC(self.viewModel, account) = self.accountTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    @weakify(self);
    [self.viewModel.executeLogin.executionSignals subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    
    [self.viewModel.loginActiveSignal subscribeNext:^(NSNumber *enable) {
        @strongify(self);
        self.loginButton.enabled = [enable boolValue];
    }];
    
    [[self.viewModel.executeLogin.executing filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }];

    [self.viewModel.executeLogin.errors subscribeNext:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = NSLocalizedString(error.domain, nil);
        [hud hide:YES afterDelay:kErrorHUDShowTime];
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
