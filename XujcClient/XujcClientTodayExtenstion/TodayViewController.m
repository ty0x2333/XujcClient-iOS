//
//  TodayViewController.m
//  XujcClientTodayExtenstion
//
//  Created by 田奕焰 on 16/5/7.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CacheUtils.h"
#import "XujcSemesterModel.h"
#import <Masonry/Masonry.h>
#import "NSDate+Week.h"
#import "LessonTimeCalculator.h"
#import "TodayEventView.h"
#import "TodayViewModel.h"

static CGFloat const kContentInterval = 8.f;

static CGFloat const kContentMarginHorizontal = 15.f;

static CGFloat const kContentMarginVertical = 10.f;

static CGFloat const kSemesterLabelFont = 14.f;
static CGFloat const kNextLessonTitleLabelFont = 14.f;

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) TodayViewModel *viewModel;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *semesterLabel;

@property (nonatomic, strong) UILabel *nextLessonTitleLabel;

@property (nonatomic, strong) NSArray<TodayEventView *> *eventViews;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewModel = [[TodayViewModel alloc] init];
    
    _contentView = [[UIView alloc] init];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kContentMarginHorizontal);
        make.right.equalTo(self.view).with.offset(-kContentMarginHorizontal);
        make.top.equalTo(self.view).with.offset(kContentMarginVertical).priorityMedium();
        make.bottom.equalTo(self.view).with.offset(-kContentMarginVertical).priorityMedium();
    }];
    
    _semesterLabel = [[UILabel alloc] init];
    _semesterLabel.textAlignment = NSTextAlignmentCenter;
    _semesterLabel.textColor = [UIColor whiteColor];
    _semesterLabel.font = [UIFont systemFontOfSize:kSemesterLabelFont];
    [_contentView addSubview:_semesterLabel];
    
    [_semesterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    
    _nextLessonTitleLabel = [[UILabel alloc] init];
    _nextLessonTitleLabel.textColor = [UIColor whiteColor];
    _nextLessonTitleLabel.text = @"下节课";
    _nextLessonTitleLabel.font = [UIFont systemFontOfSize:kNextLessonTitleLabelFont];
    [_contentView addSubview:_nextLessonTitleLabel];
    
    [_nextLessonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.semesterLabel.mas_bottom).with.offset(kContentInterval);
    }];
    
    _eventViews = [[NSArray alloc] init];
    
//    self.preferredContentSize = CGSizeMake(0, 200);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    NSArray<XujcSemesterModel *> *semesters = [[CacheUtils instance] semestersFormCache];
    XujcSemesterModel *currentSemester = [semesters firstObject];
//#warning test
//    currentSemester = nil;
//    currentSemester.semesterId = @"20151";
    
    NSArray *events = [[CacheUtils instance] lessonEventFormCacheWithSemester:currentSemester.semesterId];
    NSArray *lessonEvents = [self p_sortLessonEvents:events];
    
    NSInteger chineseDayOfWeek = [NSDate currentChineseDayOfWeek];
//#warning test
//    chineseDayOfWeek = 1;
    
    NSInteger currentLessonNumber = [[LessonTimeCalculator instance] currentLessonNumberByTime:[NSDate date]];
    NSArray *currentLessonEvents = lessonEvents[chineseDayOfWeek - 1];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startSection.sectionIndex" ascending:YES];
    currentLessonEvents = [currentLessonEvents sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
//#warning test
//    currentLessonNumber = 1;
    
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
    
    // remove old eventViews
    [_eventViews enumerateObjectsUsingBlock:^(TodayEventView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    _eventViews = nil;
    
    NSMutableArray *mutableEventViews = [[NSMutableArray alloc] init];
    __block UIView *lastView = self.nextLessonTitleLabel;
    
    [nextEvents enumerateObjectsUsingBlock:^(XujcLessonEventModel * _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
        TodayEventView *eventView = [[TodayEventView alloc] initWithViewModel:[_viewModel todayEventViewModel]];
        eventView.lessonName = event.name;
        eventView.lessonLocation = event.location;
        eventView.sectionDescription = [NSString stringWithFormat:@"%@-%@节", [event.startSection displayName], [event.endSection displayName]];
        [_contentView addSubview:eventView];
        [mutableEventViews addObject:eventView];
        
        [eventView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(lastView.mas_bottom).with.offset(kContentInterval);
        }];
        
        lastView = eventView;
    }];
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
    }];
    
    if (currentSemester == nil) {
        _semesterLabel.text = @"暂无学期数据";
        _nextLessonTitleLabel.text = nil;
    } else {
        _semesterLabel.text = currentSemester.displayName;
        if (nextEvents.count < 1) {
            _nextLessonTitleLabel.text = @"今天没有后续课程";
        }
    }
    
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - NCWidgetProviding

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

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
