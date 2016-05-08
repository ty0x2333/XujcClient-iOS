//
//  TodayViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>
@class XujcLessonEventModel;
@class TodayEventTableViewCellViewModel;

@interface TodayViewModel : NSObject

@property (nonatomic, strong) RACSignal *fetchDataSignal;

@property (nonatomic, readonly, copy) NSString *semesterName;

@property (nonatomic, readonly, assign) NSInteger nextEventsCount;

- (TodayEventTableViewCellViewModel *)todayEventTableViewCellViewModelForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end
