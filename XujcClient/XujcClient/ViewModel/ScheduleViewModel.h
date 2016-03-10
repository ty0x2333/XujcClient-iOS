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

@interface ScheduleViewModel : RequestViewModel

@property (strong, nonatomic) NSArray<NSArray<XujcCourseEvent *> *> *courseEvents;

@property (strong, nonatomic) RACSignal *fetchScheduleCourseSignal;

@property (strong, nonatomic) RACSignal *fetchTermsSignal;

- (CourseEventViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfCourseEventInSection:(NSInteger)section;

@end
