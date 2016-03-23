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

@interface ScheduleViewModel()

@property (strong, nonatomic) XujcLessonModel *xujcLesson;

@end

@implementation ScheduleViewModel

- (RACSignal *)fetchScheduleLessonSignal
{
    @weakify(self);
    RACSignal *fetchScheduleLessonSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *semesterId = self.semesterSelectorViewModel.selectedSemesterId;
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"kb.php" parameters:@{XujcServiceKeyApiKey: DYNAMIC_DATA.xujcKey, XujcServiceKeySemesterId: semesterId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *lessonEventArray = [NSMutableArray arrayWithCapacity:[responseObject count]];
    
            for (id item in responseObject) {
                XujcLessonModel *lesson = [[XujcLessonModel alloc] initWithJSONResopnse:item];
                for (XujcLessonEventModel* event in lesson.lessonEvents) {
                    [lessonEventArray addObject:event];
                }
            }
            
            [[CacheUtils instance] cacheLessonEvent:lessonEventArray inSemester:semesterId];
            
            NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:kDayCountOfWeek];
    
            for (NSInteger i = 0; i < kDayCountOfWeek; ++i) {
                [events addObject:[self p_coureEventsFromDayNumberOfWeek:lessonEventArray dayNumberOfWeek:i + 1]];
            }
            self.lessonEvents = [events copy];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSArray *lessonEventArray = [[CacheUtils instance] lessonEventFormCacheWithSemester:semesterId];
            
            NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:kDayCountOfWeek];
            
            for (NSInteger i = 0; i < kDayCountOfWeek; ++i) {
                [events addObject:[self p_coureEventsFromDayNumberOfWeek:lessonEventArray dayNumberOfWeek:i + 1]];
            }
            self.lessonEvents = [events copy];
            
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [[fetchScheduleLessonSignal setNameWithFormat:@"ScheduleViewModel fetchScheduleLessonSignal"] logError];
}

- (LessonEventViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath
{
    XujcLessonEventModel *lessonEvent = [self.lessonEvents[indexPath.section] objectAtIndex:indexPath.row];
    LessonEventViewModel *viewModel = [[LessonEventViewModel alloc] init];
    viewModel.name = lessonEvent.name;
    viewModel.location = lessonEvent.location;
    return viewModel;
}

- (NSInteger)numberOfLessonEventInSection:(NSInteger)section
{
    return [[self.lessonEvents objectAtIndex:section] count];
}

#pragma mark - Helper

- (NSArray *)p_coureEventsFromDayNumberOfWeek:(NSArray *)allLessonEvents dayNumberOfWeek:(NSInteger)dayNumberOfWeek
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (XujcLessonEventModel *event in allLessonEvents) {
        NSInteger currentDayNumberOfWeek = [NSDate dayNumberOfWeekFromString:event.studyDay];
        if (currentDayNumberOfWeek == dayNumberOfWeek){
            [result addObject:event];
        }
    }
    return result;
}

@end
