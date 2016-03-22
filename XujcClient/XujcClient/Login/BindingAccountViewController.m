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
#import "FormButton.h"

static const CGFloat kLoginButtonMarginVertical = 15.f;

@interface BindingAccountViewController()

@property (strong, nonatomic) BindingAccountViewModel *viewModel;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UITextField *accountTextField;

@property (strong, nonatomic) UITextField *apiKeyTextField;
@property (strong, nonatomic) UILabel *apiKeyLeftView;
@property (strong, nonatomic) FormButton *bindingButton;

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
    _accountTextField.ty_borderColor = [UIColor ty_border].CGColor;
    _accountTextField.ty_borderEdge = UIRectEdgeBottom;
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_accountTextField];
    
    _apiKeyLeftView = [[UILabel alloc] init];
    _apiKeyLeftView.textColor = [UIColor ty_textDisable];
    
    _apiKeyTextField = [[UITextField alloc] init];
    _apiKeyTextField.ty_borderColor = [UIColor ty_border].CGColor;
    _apiKeyTextField.ty_borderEdge = UIRectEdgeBottom;
    _apiKeyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _apiKeyTextField.leftView = _apiKeyLeftView;
    _apiKeyTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_apiKeyTextField];
    
    _bindingButton = [[FormButton alloc] init];
    [_bindingButton setTitle:NSLocalizedString(@"Binding", nil) forState:UIControlStateNormal];
    [self.view addSubview:_bindingButton];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_imageView];
    
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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] init];
    [singleTap.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    [self.view addGestureRecognizer:singleTap];
    
    [self initViewConstraints];
    
    [self bindViewModel];
    
#ifdef DEBUG
    _accountTextField.text = @"swe12023";
    [_accountTextField sendActionsForControlEvents:UIControlEventEditingChanged];
    _apiKeyTextField.text = @"szyufvxh";
    
    _bindingButton.backgroundColor = [UIColor blueColor];
//    _accountTextField.backgroundColor = [UIColor redColor];
//    _apiKeyTextField.backgroundColor = [UIColor redColor];
#endif
}

- (void)bindViewModel
{
    _bindingButton.rac_command = self.viewModel.executeBinding;
    RAC(self.viewModel, studentId) = [RACSignal merge:@[self.accountTextField.rac_textSignal, RACObserve(self.accountTextField, text)]];
    RAC(self.viewModel, apiKeySuffix) = [RACSignal merge:@[self.apiKeyTextField.rac_textSignal, RACObserve(self.apiKeyTextField, text)]];
    @weakify(self);
    [self.viewModel.executeBinding.executionSignals subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    
    [[self.viewModel.executeBinding.executionSignals concat] subscribeNext:^(id x) {
        @strongify(self);
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = NSLocalizedString(@"Account binding successfully", nil);
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, kSuccessHUDShowTime * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [hud hide:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
    [[self.viewModel.executeBinding.executing filter:^BOOL(id value) {
        return [value boolValue];
    }] subscribeNext:^(id x) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }];
    
    [self.viewModel.executeBinding.errors subscribeNext:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelText = error.localizedDescription;
        [hud hide:YES afterDelay:kErrorHUDShowTime];
    }];
}

- (void)initViewConstraints
{
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.5f);
        make.width.equalTo(self.imageView.mas_height);
    }];
    
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
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
    
    [_bindingButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.apiKeyTextField.mas_bottom).with.offset(kLoginButtonMarginVertical);
        make.left.equalTo(self.apiKeyTextField);
        make.right.equalTo(self.apiKeyTextField);
        make.height.equalTo(@(kLoginButtonHeight));
    }];
}


@end
