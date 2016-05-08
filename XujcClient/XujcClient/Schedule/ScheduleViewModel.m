//
//  ScheduleViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScheduleViewModel.h"
#import "XujcService.h"
#import "DynamicData.h"
#import "XujcLessonModel.h"
#import "XujcSemesterModel.h"
#import "CacheUtils.h"
#import "NSDate+Week.h"

#import "LessonTimeCalculator.h"

@interface ScheduleViewModel()

@property (strong, nonatomic) XujcLessonModel *xujcLesson;

@end

@implementation ScheduleViewModel

- (RACSignal *)fetchScheduleLessonSignal
{
    NSString *semesterId = self.semesterSelectorViewModel.selectedSemesterId;
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        return [[self.xujcSessionManager requestScheduleLessonSignalWithSemesterId:semesterId] subscribeNext:^(NSArray *lessonEvents) {
            self.lessonEvents = [self p_sortLessonEvents:lessonEvents];
            
            [subscriber sendNext:nil];
        } error:^(NSError *error) {
            NSArray *lessonEvents = [[CacheUtils instance] lessonEventFormCacheWithSemester:semesterId];
            self.lessonEvents = [self p_sortLessonEvents:lessonEvents];
            
            [subscriber sendError:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

- (LessonEventViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath
{
    XujcLessonEventModel *lessonEvent = [self.lessonEvents[indexPath.section] objectAtIndex:indexPath.row];
    LessonEventViewModel *viewModel = [[LessonEventViewModel alloc] initWithModel:lessonEvent];
    return viewModel;
}

- (LessonEventPopViewModel *)lessonEventPopViewModelAtIndexPath:(NSIndexPath *)indexPath
{
    XujcLessonEventModel *lessonEvent = [self.lessonEvents[indexPath.section] objectAtIndex:indexPath.row];
    return [[LessonEventPopViewModel alloc] initWithModel:lessonEvent];
}

- (NSInteger)numberOfLessonEventInSection:(NSInteger)section
{
    return [[self.lessonEvents objectAtIndex:section] count];
}

#pragma mark - Helper

- (NSArray *)p_sortLessonEvents:(NSArray *)lessonEvents
{
    NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:kDayCountOfWeek];
    for (NSInteger i = 0; i < kDayCountOfWeek; ++i) {
        [events addObject:[self p_coureEvents:lessonEvents chineseDayOfWeek:i + 1]];
    }
    return [events copy];
}

- (NSArray *)p_coureEvents:(NSArray *)allLessonEvents chineseDayOfWeek:(NSInteger)chineseDayOfWeek
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (XujcLessonEventModel *event in allLessonEvents) {
        if ([event chineseDayOfWeek] == chineseDayOfWeek){
            [result addObject:event];
        }
    }
    return result;
}

@end
