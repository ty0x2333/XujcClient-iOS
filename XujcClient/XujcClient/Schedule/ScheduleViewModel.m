//
//  ScheduleViewModel.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "ScheduleViewModel.h"
#import "XujcServer.h"
#import "DynamicData.h"
#import "XujcCourse.h"
#import "XujcSemesterModel.h"
#import "CacheUtils.h"

@interface ScheduleViewModel()

@property (strong, nonatomic) XujcCourse *xujcCourse;

@end

@implementation ScheduleViewModel

- (RACSignal *)fetchScheduleCourseSignal
{
    @weakify(self);
    RACSignal *fetchScheduleCourseSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"kb.php" parameters:@{XujcServerKeyApiKey: DYNAMIC_DATA.xujcKey, XujcServerKeySemesterId: self.semesterSelectorViewModel.selectedSemesterId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *courseEventArray = [NSMutableArray arrayWithCapacity:[responseObject count]];
    
            for (id item in responseObject) {
                XujcCourse *course = [[XujcCourse alloc] initWithJSONResopnse:item];
                for (XujcCourseEvent* event in course.courseEvents) {
                    [courseEventArray addObject:event];
                }
            }
            
            NSMutableArray *events = [[NSMutableArray alloc] initWithCapacity:kDayCountOfWeek];
    
            for (NSInteger i = 0; i < kDayCountOfWeek; ++i) {
                [events addObject:[self p_coureEventsFromDayNumberOfWeek:courseEventArray dayNumberOfWeek:i + 1]];
            }
            self.courseEvents = [events copy];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return fetchScheduleCourseSignal;
}

- (CourseEventViewModel *)cellViewModelAtIndexPath:(NSIndexPath *)indexPath
{
    XujcCourseEvent *courseEvent = [self.courseEvents[indexPath.section] objectAtIndex:indexPath.row];
    CourseEventViewModel *viewModel = [[CourseEventViewModel alloc] init];
    viewModel.name = courseEvent.name;
    viewModel.location = courseEvent.location;
    return viewModel;
}

- (NSInteger)numberOfCourseEventInSection:(NSInteger)section
{
    return [[self.courseEvents objectAtIndex:section] count];
}

#pragma mark - Helper

- (NSArray *)p_coureEventsFromDayNumberOfWeek:(NSArray *)allCourseEvents dayNumberOfWeek:(NSInteger)dayNumberOfWeek
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (XujcCourseEvent *event in allCourseEvents) {
        NSInteger currentDayNumberOfWeek = [NSDate dayNumberOfWeekFromString:event.studyDay];
        if (currentDayNumberOfWeek == dayNumberOfWeek){
            [result addObject:event];
        }
    }
    return result;
}

@end
