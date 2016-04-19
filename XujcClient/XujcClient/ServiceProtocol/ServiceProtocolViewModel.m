//
//  ServiceProtocolViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/4/11.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ServiceProtocolViewModel.h"

@implementation ServiceProtocolViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Service Protocol"
                                                                                                          ofType:@"html"]]];
    }
    return self;
}

@end
