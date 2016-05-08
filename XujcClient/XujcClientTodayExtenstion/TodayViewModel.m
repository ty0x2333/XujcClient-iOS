//
//  TodayViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TodayViewModel.h"
#import "XujcSemesterModel.h"
#import "CacheUtils.h"
#import "TodayEventViewModel.h"
#import "NSDate+Week.h"
#import "LessonTimeCalculator.h"
#import "TodayEventTableViewCellViewModel.h"

@interface TodayViewModel()

@property (nonatomic, copy) NSString *semesterName;
@property (nonatomic, strong) NSArray<XujcLessonEventModel *> *nextEvents;
@property (nonatomic, assign) NSInteger nextEventsCount;

@end

@implementation TodayViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _fetchDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSArray<XujcSemesterModel *> *semesters = [[CacheUtils instance] semestersFormCache];
            XujcSemesterModel *currentSemester = [semesters firstObject];
//            #warning test
//            currentSemester.semesterId = @"20151";
            
            NSArray *events = [[CacheUtils instance] lessonEventFormCacheWithSemester:currentSemester.semesterId];
            NSArray *lessonEvents = [self p_sortLessonEvents:events];
            
            NSInteger chineseDayOfWeek = [NSDate currentChineseDayOfWeek];
//            #warning test
//            chineseDayOfWeek = 1;
            
            NSInteger currentLessonNumber = [[LessonTimeCalculator instance] currentLessonNumberByTime:[NSDate date]];
            NSArray *currentLessonEvents = lessonEvents[chineseDayOfWeek - 1];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startSection.sectionIndex" ascending:YES];
            currentLessonEvents = [currentLessonEvents sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            
//            #warning test
//            currentLessonNumber = 1;
            
            NSMutableArray<XujcLessonEventModel *> *nextEvents = [[NSMutableArray alloc] init];
            NSInteger nextEventLessonNumber = 0;
            
            for (NSUInteger i = 0; i < currentLessonEvents.count; ++i) {
                XujcLessonEventModel *event = currentLessonEvents[i];
                if (nextEvents.count < 1) {
                    if (event.startSection.sectionIndex > currentLessonNumber) {
                        [nextEvents addObject:event];
                        nextEventLessonNumber = event.startSection.sectionIndex;
                    }
                } else {
                    if (event.startSection.sectionIndex == nextEventLessonNumber) {
                        [nextEvents addObject:event];
                    } else {
                        break;
                    }
                }
            }
            
            self.nextEvents = [nextEvents copy];
            self.nextEventsCount = self.nextEvents.count;
            
            self.semesterName = currentSemester.displayName;
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{}];
        }];
    }
    return self;
}

- (TodayEventViewModel *)todayEventViewModel
{
    return [[TodayEventViewModel alloc] init];
}

- (TodayEventTableViewCellViewModel *)todayEventTableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XujcLessonEventModel *model = self.nextEvents[indexPath.row];
    return [[TodayEventTableViewCellViewModel alloc] initWithModel:model];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return _nextEvents.count;
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
