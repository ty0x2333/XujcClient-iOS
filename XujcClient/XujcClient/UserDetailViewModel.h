//
//  UserDetailViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;

@interface UserDetailViewModel : NSObject

@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *avatar;
@property (copy, nonatomic) NSString *email;

@end
