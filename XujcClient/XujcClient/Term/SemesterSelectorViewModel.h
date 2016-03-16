//
//  SemesterSelectorViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/12.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "XujcSemesterModel.h"
#import "SemesterTableViewCellViewModel.h"

@interface SemesterSelectorViewModel : RequestViewModel

@property (strong, nonatomic) NSArray<XujcSemesterModel *> *semesters;

@property (strong, nonatomic) RACSignal *selectedSemesterNameSignal;

@property (strong, nonatomic) RACSignal *selectedSemesterIdSignal;

@property (assign, nonatomic) NSInteger selectedIndex;

- (NSString *)selectedSemesterId;

- (SemesterTableViewCellViewModel *)semesterTableViewCellViewModelAtIndex:(NSInteger)index;

@end
