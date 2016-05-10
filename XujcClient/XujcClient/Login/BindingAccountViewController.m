//
//  ViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 15/10/30.
//  Copyright © 2015年 luckytianyiyan. All rights reserved.
//

#import "BindingAccountViewController.h"
#import "DynamicData.h"
#import "UIView+BorderLine.h"
#import "XujcUserModel.h"
#import "SSKeychain.h"
#import "LoginLayoutConfigs.h"
#import "FormButton.h"

static const CGFloat kLoginButtonMarginVertical = 15.f;

static const CGFloat kDescriptionLabelFontSize = 10.f;

@interface BindingAccountViewController()

@property (strong, nonatomic) BindingAccountViewModel *viewModel;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UITextField *accountTextField;

@property (strong, nonatomic) UITextField *apiKeyTextField;
@property (strong, nonatomic) UILabel *apiKeyLeftView;
@property (strong, nonatomic) FormButton *bindingButton;

@property (strong, nonatomic) MASConstraint *logoTopConstraint;
@property (strong, nonatomic) MASConstraint *logoBottomConstraint;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

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
    self.screenName = @"Binding Account Screen";
    
    _accountTextField = [[UITextField alloc] init];
    _accountTextField.ty_borderColor = [UIColor ty_border].CGColor;
    _accountTextField.ty_borderEdge = UIRectEdgeBottom;
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountTextField.placeholder = NSLocalizedString(@"Student ID", nil);
    [self.view addSubview:_accountTextField];
    
    _apiKeyLeftView = [[UILabel alloc] init];
    _apiKeyLeftView.textColor = [UIColor ty_textDisable];
    
    _apiKeyTextField = [[UITextField alloc] init];
    _apiKeyTextField.ty_borderColor = [UIColor ty_border].CGColor;
    _apiKeyTextField.ty_borderEdge = UIRectEdgeBottom;
    _apiKeyTextField.placeholder = NSLocalizedString(@"API Key", nil);
    _apiKeyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _apiKeyTextField.leftView = _apiKeyLeftView;
    _apiKeyTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_apiKeyTextField];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor ty_textGray];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = NSLocalizedString(@"Bind Account", nil);
    [self.view addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.textColor = [UIColor ty_textGray];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.font = [UIFont systemFontOfSize:kDescriptionLabelFontSize];
    _descriptionLabel.text = NSLocalizedString(@"Bind Description", nil);
    _descriptionLabel.numberOfLines = 0;
    [self.view addSubview:_descriptionLabel];
    
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
    RAC(self.apiKeyLeftView, text) = [[_accountTextField.rac_textSignal merge:RACObserve(_accountTextField, text)] map:^id(NSString *text) {
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
        self.logoTopConstraint = make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(0.5f);
        make.width.equalTo(self.imageView.mas_height);
    }];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.left.equalTo(self.view).with.offset(kLoginContentMarginHorizontal);
        make.right.equalTo(self.view).with.offset(-kLoginContentMarginHorizontal);
        make.height.equalTo(@(kLoginTextFieldHeight));
    }];
    
    [_descriptionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.view).with.offset(kLoginContentMarginHorizontal);
        make.right.equalTo(self.view).with.offset(-kLoginContentMarginHorizontal);
        make.height.equalTo(@(kLoginTextFieldHeight));
    }];
    
    [_accountTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom);
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
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    @weakify(self);
    [[defaultCenter ty_keyboardWillShowSignal] subscribeNext:^(NSNotification *note) {
        @strongify(self);
        NSDictionary *userInfo = note.userInfo;
        // Get keyboard animation.
        NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration = durationValue.doubleValue;
        
        NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
        UIViewAnimationCurve animationCurve = curveValue.intValue;
        
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.logoTopConstraint uninstall];
            [self.logoBottomConstraint uninstall];
            self.logoBottomConstraint = make.bottom.equalTo(self.mas_topLayoutGuideBottom);
        }];
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(animationCurve << 16)
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
    }];
    
    [[defaultCenter ty_keyboardWillHideSignal] subscribeNext:^(NSNotification *note) {
        @strongify(self);
        NSDictionary *userInfo = note.userInfo;
        // Get keyboard animation.
        NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval animationDuration = durationValue.doubleValue;
        
        NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
        UIViewAnimationCurve animationCurve = curveValue.intValue;
        
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.logoTopConstraint uninstall];
            [self.logoBottomConstraint uninstall];
            self.logoTopConstraint = make.top.equalTo(self.mas_topLayoutGuideBottom);
        }];
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:(animationCurve << 16)
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:nil];
    }];

}


@end
