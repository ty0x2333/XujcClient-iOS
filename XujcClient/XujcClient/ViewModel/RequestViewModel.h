//
//  RequestViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface RequestViewModel : NSObject

@property (strong, readonly, nonatomic) AFHTTPSessionManager *sessionManager;

@end
