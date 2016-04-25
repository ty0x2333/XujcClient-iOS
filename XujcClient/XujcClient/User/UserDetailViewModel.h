//
//  UserDetailViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
@class UserModel;
@class XujcInformationViewModel;

@interface UserDetailViewModel : RequestViewModel

@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *phone;

@property (strong, nonatomic) RACSignal *fetchXujcInformationSignal;
@property (strong, nonatomic) RACSignal *fetchProfileSignal;

- (XujcInformationViewModel *)xujcInformationViewModel;

@end
