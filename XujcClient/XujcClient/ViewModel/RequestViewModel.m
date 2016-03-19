//
//  RequestViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/5.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "TYServer.h"
#import "XujcService.h"

@interface RequestViewModel()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) AFHTTPSessionManager *xujcSessionManager;

@end

@implementation RequestViewModel

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager ty_manager];
    }
    return _sessionManager;
}

- (AFHTTPSessionManager *)xujcSessionManager
{
    if (!_xujcSessionManager) {
        _xujcSessionManager = [AFHTTPSessionManager xujc_manager];
    }
    return _xujcSessionManager;
}

- (void)dealloc
{
    [_sessionManager invalidateSessionCancelingTasks:YES];
    [_xujcSessionManager invalidateSessionCancelingTasks:YES];
}

@end
