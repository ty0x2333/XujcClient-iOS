//
//  VerificationCodeTextField.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/30.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VerificationCodeTextFieldViewModel;

@interface VerificationCodeTextField : UITextField

- (instancetype)initWithViewModel:(VerificationCodeTextFieldViewModel *)viewModel;

@property (readonly, strong, nonatomic) UIButton *button;

@end
