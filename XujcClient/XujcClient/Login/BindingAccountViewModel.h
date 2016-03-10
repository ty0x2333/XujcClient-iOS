//
//  BindingAccountViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"

@interface BindingAccountViewModel : RequestViewModel

@property (copy, nonatomic) NSString *studentId;
@property (copy, nonatomic) NSString *apiKeySuffix;

@property (strong, nonatomic) RACCommand *executeBinding;

@property (strong, nonatomic) RACSignal *validStudentIdSignal;

@property (strong, nonatomic) RACSignal *validApiKeySuffixSignal;

@property (strong, nonatomic) RACSignal *bindingActiveSignal;

@end
