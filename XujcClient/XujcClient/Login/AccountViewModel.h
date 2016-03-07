//
//  AccountViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestViewModel.h"

@interface AccountViewModel : RequestViewModel

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *password;

@property (strong, nonatomic) RACSignal *validEmailSignal;
@property (strong, nonatomic) RACSignal *validPasswordSignal;

@end
