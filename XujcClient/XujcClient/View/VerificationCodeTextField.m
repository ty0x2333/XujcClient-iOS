//
//  VerificationCodeTextField.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/30.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "VerificationCodeTextField.h"
#import "UIView+BorderLine.h"
#import "VerificationCodeTextFieldViewModel.h"
#import "AppUtils.h"

static CGFloat const kVerificationButtonWidth = 100.f;
static CGFloat const kVerificationButtonHeight = 34.f;

@interface VerificationCodeTextField()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) VerificationCodeTextFieldViewModel *viewModel;

@end

@implementation VerificationCodeTextField

- (instancetype)initWithViewModel:(VerificationCodeTextFieldViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
        self.ty_borderColor = [UIColor ty_border].CGColor;
        self.ty_borderEdge = UIRectEdgeBottom;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.placeholder = NSLocalizedString(@"Verification Code", nil);
        
        _button = [[UIButton alloc] initWithFrame:(CGRect){CGPointZero, CGSizeMake(kVerificationButtonWidth, kVerificationButtonHeight)}];
        _button.layer.borderWidth = .5f;
        _button.layer.cornerRadius = 4.f;
        _button.layer.borderColor = [UIColor ty_border].CGColor;
        _button.titleLabel.font = self.font;
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [_button setTitle:NSLocalizedString(@"Get Code", nil) forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor ty_textBlack] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor ty_textDisable] forState:UIControlStateDisabled];
        self.rightView = _button;
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        self.button.rac_command = self.viewModel.executeGetVerificationCode;
        RAC(self.viewModel, verificationCode) = [RACSignal merge:@[self.rac_textSignal, RACObserve(self, text)]];
        @weakify(self);
        [[self.viewModel.executeGetVerificationCode.executionSignals concat] subscribeNext:^(NSNumber *value) {
            @strongify(self);
            [self.button setTitle:[NSString stringWithFormat:@"%zd", [value integerValue]] forState:UIControlStateNormal];
        }];
        
        [[self.viewModel.executeGetVerificationCode.executing filter:^BOOL(NSNumber *value) {
            return ![value boolValue];
        }] subscribeNext:^(id x) {
            [self.button setTitle:NSLocalizedString(@"Get Code", nil) forState:UIControlStateNormal];
        }];
        
        [[self.viewModel.executeGetVerificationCode.errors deliverOn:[RACScheduler mainThreadScheduler]]
         subscribeNext:^(NSError *error) {
            @strongify(self);
            UIViewController *controller = [AppUtils viewController:self];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = error.localizedDescription;
            [hud hide:YES afterDelay:kErrorHUDShowTime];
        }];
    }
    return self;
}

@end
