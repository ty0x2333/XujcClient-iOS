//
//  ScheduleViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "SemesterBaseViewModel.h"
#import "LessonEventViewModel.h"
#import "XujcLessonEventModel.h"

@interface ScheduleViewModel : SemesterBaseViewModel

/**
 *  @brief lessonEvents[numberOfWeek][numberOfEvent]
 */
@property (strong, nonatomic) NSArray<NSArray<XujcLessonEventModel *> *> *lessonEvents;

@property (strong, nonatomic) RACSignal *fetchScheduleLessonSignal;

- (LessonEventViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfLessonEventInSection:(NSInteger)section;

@end
