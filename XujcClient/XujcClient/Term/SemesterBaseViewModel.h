//
//  SemesterBaseViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/13.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "SemesterSelectorViewModel.h"

@interface SemesterBaseViewModel : RequestViewModel

@property (strong, nonatomic) NSArray<XujcSemesterModel *> *semesters;

@property (strong, readonly, nonatomic) SemesterSelectorViewModel *semesterSelectorViewModel;

@end
