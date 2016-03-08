//
//  ViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 15/10/30.
//  Copyright © 2015年 luckytianyiyan. All rights reserved.
//

#import "BindingAccountViewController.h"
#import "XujcAPI.h"
#import "DynamicData.h"
#import "UIView+BorderLine.h"
#import "XujcUser.h"
#import "SSKeychain.h"
#import "LoginLayoutConfigs.h"

static const CGFloat kLoginButtonMarginVertical = 15.f;

@interface BindingAccountViewController()

@property (strong, nonatomic) BindingAccountViewModel *viewModel;

@property (strong, nonatomic) UITextField *accountTextField;

@property (strong, nonatomic) UITextField *apiKeyTextField;
@property (strong, nonatomic) UILabel *apiKeyLeftView;
@property (strong, nonatomic) UIButton *loginButton;

@end

@implementation BindingAccountViewController

- (instancetype)initWithViewModel:(BindingAccountViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.ty_borderColor = [UIColor blackColor].CGColor;
    _accountTextField.ty_borderEdge = UIRectEdgeBottom;
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_accountTextField];
    
    _apiKeyLeftView = [[UILabel alloc] init];
    
    _apiKeyTextField = [[UITextField alloc] init];
    _apiKeyTextField.ty_borderColor = [UIColor blackColor].CGColor;
    _apiKeyTextField.ty_borderEdge = UIRectEdgeBottom;
    _apiKeyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _apiKeyTextField.leftView = _apiKeyLeftView;
    _apiKeyTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_apiKeyTextField];
    
    _loginButton = [[UIButton alloc] init];
    [_loginButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = kLoginLayoutButtonRadius;
    [_loginButton addTarget:self action:@selector(onLoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    // APIKey LeftLabel autosize
    @weakify(self);
    [RACObserve(self.apiKeyLeftView, text) subscribeNext:^(id x) {
        @strongify(self);
        [self.apiKeyLeftView sizeToFit];
    }];
    
    // Bing apiKeyLeftView.text = _accountTextField.text
    RAC(self.apiKeyLeftView, text) = [_accountTextField.rac_textSignal map:^id(NSString *text) {
        return [NSString isEmpty:text] ? text : [NSString stringWithFormat:@"%@-", text];
    }];
    
    [self initViewConstraints];
    
#ifdef DEBUG
    _accountTextField.text = @"swe12023";
    [_accountTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    _apiKeyTextField.text = @"szyufvxh";
    
    _loginButton.backgroundColor = [UIColor blueColor];
//    _accountTextField.backgroundColor = [UIColor redColor];
//    _apiKeyTextField.backgroundColor = [UIColor redColor];
#endif
}

- (void)initViewConstraints
{
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.centerY);
        make.left.equalTo(self.view).with.offset(kLoginContentMarginHorizontal);
        make.right.equalTo(self.view).with.offset(-kLoginContentMarginHorizontal);
        make.height.equalTo(@(kLoginTextFieldHeight));
    }];
    
    [_apiKeyTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom);
        make.left.equalTo(self.accountTextField);
        make.right.equalTo(self.accountTextField);
        make.height.equalTo(self.accountTextField);
    }];
    
    [_loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.apiKeyTextField.mas_bottom).with.offset(kLoginButtonMarginVertical);
        make.left.equalTo(self.apiKeyTextField);
        make.right.equalTo(self.apiKeyTextField);
        make.height.equalTo(@(kLoginButtonHeight));
    }];
}

#pragma mark - Event Response

- (void)onLoginButtonClicked:(id)sender
{
    NSString* apiKey = [NSString stringWithFormat:@"%@%@", _apiKeyLeftView.text, _apiKeyTextField.text];
    [XujcAPI userInfomation:apiKey successBlock:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TyLogDebug(@"Success Response: %@", responseObject);
        XujcUser *user = [[XujcUser alloc] initWithJSONResopnse:responseObject];
        TyLogDebug(@"User Infomation: %@", [user description]);
        DYNAMIC_DATA.APIKey = apiKey;
        DYNAMIC_DATA.user = user;
        [DYNAMIC_DATA flush];
#warning must be more safe
        [SSKeychain setPassword:_apiKeyTextField.text forService:@"Xujc" account:user.studentId];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failureBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
        TyLogFatal(@"Failure:\n\tstatusCode: %ld,\n\tdetail: %@", httpResponse.statusCode, error);
    }];
}


@end
