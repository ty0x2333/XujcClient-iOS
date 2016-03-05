//
//  RequestViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "AFHTTPSessionManager+TYServer.h"

@interface RequestViewModel()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation RequestViewModel

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager ty_manager];
    }
    return _sessionManager;
}

- (void)dealloc
{
    [self.sessionManager invalidateSessionCancelingTasks:YES];
}


@end
