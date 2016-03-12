//
//  ScheduleViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "RequestViewModel.h"
#import "CourseEventViewModel.h"
#import "XujcCourseEvent.h"
#import "TermSelectorViewModel.h"

@interface ScheduleViewModel : RequestViewModel

@property (strong, nonatomic) NSArray<NSArray<XujcCourseEvent *> *> *courseEvents;

@property (strong, nonatomic) RACSignal *fetchScheduleCourseSignal;

- (CourseEventViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, readonly, nonatomic) TermSelectorViewModel *termSelectorViewModel;

- (NSInteger)numberOfCourseEventInSection:(NSInteger)section;

@end
