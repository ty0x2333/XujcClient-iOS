//
//  ChangePasswordViewController.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordViewModel.h"
#import "InputTableViewCell.h"
#import "VerificationCodeTableViewCell.h"
#import "FormButton.h"

static CGFloat const kTableViewTableFooterHeight = 40.f;

static CGFloat const kOKButtonMarginHorizontal = 10.f;

static NSString * const kInputTableViewCellReuseIdentifier = @"InputTableViewCellReuseIdentifier";
static NSString * const kVerificationCodeTableViewCellReuseIdentifier = @"VerificationCodeTableViewCellReuseIdentifier";

@interface ChangePasswordViewController()<UITableViewDataSource>

@property (nonatomic, strong) ChangePasswordViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) FormButton *okButton;

@end

@implementation ChangePasswordViewController

- (instancetype)initWithViewModel:(ChangePasswordViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Change Password Screen";
    self.title = NSLocalizedString(@"Change Password", nil);
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(0, kTableViewTableFooterHeight)}];
    
    _okButton = [[FormButton alloc] init];
    [_okButton setTitle:@"完成" forState:UIControlStateNormal];
    _okButton.backgroundColor = [UIColor ty_buttonBackground];
    
    [tableFooterView addSubview:_okButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.tableFooterView = tableFooterView;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[InputTableViewCell class] forCellReuseIdentifier:kInputTableViewCellReuseIdentifier];
    [_tableView registerClass:[VerificationCodeTableViewCell class] forCellReuseIdentifier:kVerificationCodeTableViewCellReuseIdentifier];
    _tableView.dataSource = self;
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    [_okButton makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(tableFooterView).with.offset(kOKButtonMarginHorizontal);
        make.width.equalTo(self.tableView).with.offset(-2 * kOKButtonMarginHorizontal);
        make.top.bottom.equalTo(tableFooterView);
    }];
    
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _okButton.rac_command = self.viewModel.executeChangePassword;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        VerificationCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kVerificationCodeTableViewCellReuseIdentifier forIndexPath:indexPath];
        cell.verificationCodeTextFieldViewModel = [_viewModel verificationCodeTextFieldViewModel];
        cell.inputLabel.text = @"验证码";
        return cell;
    }
    InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kInputTableViewCellReuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        _phoneTextField = cell.textField;
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.inputLabel.text = @"手机号";
        RAC(self.viewModel, phone) = [[RACSignal merge:@[RACObserve(self.phoneTextField, text), self.phoneTextField.rac_textSignal]] takeUntil:cell.rac_prepareForReuseSignal];
    } else if (indexPath.row == 2) {
        _passwordTextField = cell.textField;
        cell.textField.secureTextEntry = YES;
        cell.inputLabel.text = @"新密码";
        RAC(self.viewModel, password) = [[RACSignal merge:@[RACObserve(self.passwordTextField, text), self.passwordTextField.rac_textSignal]] takeUntil:cell.rac_prepareForReuseSignal];
    }
    
#warning test
    _phoneTextField.text = @"18559499636";
    _passwordTextField.text = @"111111";
    
    return cell;
}

@end
