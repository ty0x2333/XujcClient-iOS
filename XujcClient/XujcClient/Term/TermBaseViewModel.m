//
//  TermBaseViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TermBaseViewModel.h"

@interface TermBaseViewModel()

@property (strong, nonatomic) TermSelectorViewModel *termSelectorViewModel;

@end

@implementation TermBaseViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _termSelectorViewModel = [[TermSelectorViewModel alloc] init];
    }
    return self;
}

@end
