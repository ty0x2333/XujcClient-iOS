//
//  UserModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/6.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (strong, nonatomic) NSString *nikename;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *avatar;

@property (strong, nonatomic) NSString *createdTime;
@end
