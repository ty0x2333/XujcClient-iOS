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
#import "BindingAccountViewController.h"
#import "FormButton.h"

@interface LoginViewController()

@property (strong, nonatomic) LoginTextFieldGroupView *loginTextFieldGroupView;
@property (strong, nonatomic) LoginTextFieldGroupView *signupTextFieldGroupView;

@property (strong, nonatomic) UIImageView *logoImageView;

@property (strong, nonatomic) UITextField *accountTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) FormButton *loginButton;

@property (strong, nonatomic) UITextField *signupNicknameTextField;
@property (strong, nonatomic) UITextField *signupEmailTextField;
@property (strong, nonatomic) UITextField *signupPasswordTextField;
@property (strong, nonatomic) FormButton *signupButton;

@property (strong, nonatomic) UIButton *switchButton;

@property (strong, nonatomic) MASConstraint *loginTextFieldGroupViewRightConstraint;

@property (strong, nonatomic) LoginViewModel *loginViewModel;
@property (strong, nonatomic) SignupViewModel *signupViewModel;
@end

@implementation LoginViewController

- (instancetype)initWithLoginViewModel:(LoginViewModel *)loginViewModel andSignupViewModel:(SignupViewModel *)signupViewModel
{
    if (self = [super init]) {
        _loginViewModel = loginViewModel;
        _signupViewModel = signupViewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_logoImageView];
    
    _loginTextFieldGroupView = [[LoginTextFieldGroupView alloc] initWithItemHeight:kLoginTextFieldHeight];
    [self.view addSubview:_loginTextFieldGroupView];
    
    _accountTextField = [self p_textFieldWithPlaceholder:@"EmailOrPhone"];
    _accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [_loginTextFieldGroupView addSubview:_accountTextField];
    
    _passwordTextField = [self p_textFieldWithPlaceholder:@"Password"];
    [_loginTextFieldGroupView addSubview:_passwordTextField];
    
    _signupTextFieldGroupView = [[LoginTextFieldGroupView alloc] initWithItemHeight:kLoginTextFieldHeight];
    [self.view addSubview:_signupTextFieldGroupView];
    
    _signupNicknameTextField = [self p_textFieldWithPlaceholder:@"Nickname"];
    [_signupTextFieldGroupView addSubview:_signupNicknameTextField];
    
    _signupEmailTextField = [self p_textFieldWithPlaceholder:@"Email"];
    _signupEmailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [_signupTextFieldGroupView addSubview:_signupEmailTextField];
    
    _signupPasswordTextField = [self p_textFieldWithPlaceholder:@"Password"];
    [_signupTextFieldGroupView addSubview:_signupPasswordTextField];
    
    _loginButton = [[FormButton alloc] init];
    [_loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];
    
    _signupButton = [[FormButton alloc] init];
    [_signupButton setTitle:NSLocalizedString(@"Signup", nil) forState:UIControlStateNormal];
    [self.view addSubview:_signupButton];
    
    _switchButton = [[UIButton alloc] init];
    [_switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:_switchButton];
    
    [self initConstraints];
    
    // Binding
    [self bindSwitchAnimation];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    [self bindViewModel];
    
    // load account cache
    self.accountTextField.text = [_loginViewModel currentAccount];
    self.passwordTextField.text = [_loginViewModel currentAccountPassword];
}

- (void)initConstraints
{
    [_logoImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
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
    // Login
    _loginButton.rac_command = self.loginViewModel.executeLogin;
    RAC(self.loginViewModel, account) = [RACSignal merge:@[self.accountTextField.rac_textSignal, RACObserve(self.accountTextField, text)]];
    RAC(self.loginViewModel, password) = [RACSignal merge:@[self.passwordTextField.rac_textSignal, RACObserve(self.passwordTextField, text)]];
    @weakify(self);
    [self.loginViewModel.executeLogin.executionSignals subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    
    [[self.loginViewModel.executeLogin.executionSignals concat] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[self.loginViewModel.executeLogin.executing filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }];

    [self.loginViewModel.executeLogin.errors subscribeNext:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.localizedDescription;
        [hud hide:YES afterDelay:kErrorHUDShowTime];
    }];
    
    // Signup
    _signupButton.rac_command = self.signupViewModel.executeSignup;
    RAC(self.signupViewModel, nickname) = [RACSignal merge:@[self.signupNicknameTextField.rac_textSignal, RACObserve(self.signupNicknameTextField, text)]];
    RAC(self.signupViewModel, account) = [RACSignal merge:@[self.signupEmailTextField.rac_textSignal, RACObserve(self.signupEmailTextField, text)]];
    RAC(self.signupViewModel, password) = [RACSignal merge:@[self.signupPasswordTextField.rac_textSignal, RACObserve(self.signupPasswordTextField, text)]];

    [self.signupViewModel.executeSignup.executionSignals subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    
    [[self.signupViewModel.executeSignup.executionSignals concat] subscribeNext:^(NSString *message) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        if (hud != nil) {
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = NSLocalizedString(message, nil);
            [hud hide:YES afterDelay:kSuccessHUDShowTime];
        }
        self.switchButton.selected = NO;
    }];
    
    [[self.signupViewModel.executeSignup.executing filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }];
    
    [self.signupViewModel.executeSignup.errors subscribeNext:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.localizedDescription;
        [hud hide:YES afterDelay:kErrorHUDShowTime];
    }];

}

#pragma mark - Event Response

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Helper

- (UITextField *)p_textFieldWithPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] init];
    textField.ty_borderColor = [UIColor ty_border].CGColor;
    textField.ty_borderEdge = UIRectEdgeBottom;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.placeholder = NSLocalizedString(placeholder, nil);
    return textField;
}

@end
