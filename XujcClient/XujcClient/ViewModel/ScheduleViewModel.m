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
#import "XujcTerm.h"
#import "CacheUtils.h"

@interface ScheduleViewModel()

@property (strong, nonatomic) XujcCourse *xujcCourse;
@property (strong, nonatomic) XujcTerm *selectedTerm;

@property (strong, nonatomic) NSArray<XujcTerm *> *terms;

@end

@implementation ScheduleViewModel


- (RACSignal *)fetchScheduleCourseSignal
{
    @weakify(self);
    RACSignal *fetchScheduleCourseSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"kb.php" parameters:@{XujcServerKeyApiKey: DYNAMIC_DATA.xujcKey, XujcServerKeyTermId: self.selectedTerm.termId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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

- (RACSignal *)fetchTermsSignal
{
    @weakify(self);
    RACSignal *fetchTermsSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self.xujcSessionManager GET:@"kb.php" parameters:@{XujcServerKeyApiKey: DYNAMIC_DATA.xujcKey} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            @strongify(self);
            NSArray *termIds = [responseObject allKeys];
            NSMutableArray *termArray = [NSMutableArray arrayWithCapacity:termIds.count];
            for (id key in termIds) {
                XujcTerm *term = [[XujcTerm alloc] init];
                term.termId = key;
                term.displayName = responseObject[key];
                [termArray addObject:term];
            }
            
            [[CacheUtils instance] cacheTerms:termArray];
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"termId" ascending:NO];
            self.terms = [termArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
            self.selectedTerm = [self.terms firstObject];
            
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [[fetchTermsSignal setNameWithFormat:@"fetchTermsSignal"] logAll];
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
