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

static CGFloat const kContentInterval = 8.f;

static CGFloat const kContentMarginHorizontal = 15.f;

static CGFloat const kContentMarginVertical = 10.f;

static CGFloat const kSemesterLabelFont = 14.f;
static CGFloat const kNextLessonTitleLabelFont = 14.f;

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *semesterLabel;

@property (nonatomic, strong) UILabel *nextLessonTitleLabel;

@property (nonatomic, strong) UILabel *lessonNameLabel;

@property (nonatomic, strong) UILabel *lessonLocationLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentView = [[UIView alloc] init];
    [self.view addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(kContentMarginHorizontal);
        make.right.equalTo(self.view).with.offset(-kContentMarginHorizontal);
        make.top.equalTo(self.view).with.offset(kContentMarginVertical).priorityMedium();
        make.bottom.equalTo(self.view).with.offset(-kContentMarginVertical).priorityMedium();
    }];
    
    _semesterLabel = [[UILabel alloc] init];
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
    
    _lessonNameLabel = [[UILabel alloc] init];
    _lessonNameLabel.numberOfLines = 0;
    _lessonNameLabel.textColor = [UIColor whiteColor];
    [_contentView addSubview:_lessonNameLabel];
    
    [_lessonNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.nextLessonTitleLabel.mas_bottom).with.offset(kContentInterval);
    }];
    
    _lessonLocationLabel = [[UILabel alloc] init];
    _lessonLocationLabel.numberOfLines = 0;
    _lessonLocationLabel.textColor = [UIColor whiteColor];
    [_contentView addSubview:_lessonLocationLabel];
    
    [_lessonLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.lessonNameLabel.mas_bottom).with.offset(kContentInterval);
    }];
    
//    self.preferredContentSize = CGSizeMake(0, 200);
    
#warning test
    _contentView.backgroundColor = [UIColor redColor];
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
//    TyLogDebug(@"Current Semester: %@", currentSemester.displayName);
    self.semesterLabel.text = currentSemester.displayName;
    
    NSArray *events = [[CacheUtils instance] lessonEventFormCacheWithSemester:currentSemester.semesterId];
    NSArray *lessonEvents = [self p_sortLessonEvents:events];
    
    NSInteger chineseDayOfWeek = [NSDate currentChineseDayOfWeek];
    NSInteger currentLessonNumber = [[LessonTimeCalculator instance] currentLessonNumberByTime:[NSDate date]];
    NSArray *currentLessonEvents = lessonEvents[chineseDayOfWeek - 1];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startSection.sectionIndex" ascending:YES];
    currentLessonEvents = [currentLessonEvents sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    XujcLessonEventModel *nextEvent = nil;
    
    for (NSUInteger i = 0; i < currentLessonEvents.count; ++i) {
        XujcLessonEventModel *event = currentLessonEvents[i];
        if (event.startSection.sectionIndex > currentLessonNumber) {
            nextEvent = event;
            break;
        }
    }
    
//#warning test
//    nextEvent = [[XujcLessonEventModel alloc] init];
//    nextEvent.name = @"课程名字课程名字课程名字课程名字课程名字课程名字";
//    nextEvent.location = @"课程地点课程地点课程地点课程地点课程地点课程地点";
    
    
    if (nextEvent == nil) {
        _nextLessonTitleLabel.text = @"今天没有后续课程";
        return;
    }
    
    _lessonNameLabel.text = nextEvent.name;
    _lessonLocationLabel.text = nextEvent.location;
    
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
