//
//  ScheduleViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScheduleViewModel.h"

@implementation ScheduleViewModel

#pragma mark - Helper
- (void)p_saveTerms:(NSArray *)terms
{
    NSMutableArray *termDataArray = [NSMutableArray arrayWithCapacity:terms.count];
    for (XujcTerm *term in terms) {
        [termDataArray addObject:[term data]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:termDataArray forKey:kUserDefaultsKeyXujcTerms];
}

@end
