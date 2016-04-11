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

static NSString * const kInputTableViewCellReuseIdentifier = @"InputTableViewCellReuseIdentifier";
static NSString * const kVerificationCodeTableViewCellReuseIdentifier = @"VerificationCodeTableViewCellReuseIdentifier";

@interface ChangePasswordViewController()<UITableViewDataSource>

@property (nonatomic, strong) ChangePasswordViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

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
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[InputTableViewCell class] forCellReuseIdentifier:kInputTableViewCellReuseIdentifier];
    [_tableView registerClass:[VerificationCodeTableViewCell class] forCellReuseIdentifier:kVerificationCodeTableViewCellReuseIdentifier];
    _tableView.dataSource = self;
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    _phoneTextField = [[UITextField alloc] init];
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
        cell.inputLabel.text = @"手机号";
    } else if (indexPath.row == 2) {
        _passwordTextField = cell.textField;
        cell.inputLabel.text = @"新密码";
    }
    return cell;
}

@end
