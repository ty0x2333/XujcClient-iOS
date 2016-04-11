//
//  VerificationCodeTableViewCell.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerificationCodeTextField.h"
#import "VerificationCodeTextFieldViewModel.h"

@interface VerificationCodeTableViewCell : UITableViewCell

@property (nonatomic, strong) VerificationCodeTextFieldViewModel *verificationCodeTextFieldViewModel;

@property (nonatomic, readonly, strong) UILabel *inputLabel;

@property (nonatomic, readonly, strong) VerificationCodeTextField *verificationCodeTextField;

@end
