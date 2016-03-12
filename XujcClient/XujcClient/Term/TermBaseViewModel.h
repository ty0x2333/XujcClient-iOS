//
//  TermBaseViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "TermSelectorViewModel.h"

@interface TermBaseViewModel : RequestViewModel

@property (strong, readonly, nonatomic) TermSelectorViewModel *termSelectorViewModel;

@end
