/**
 * @file ScheduleViewController.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "ScheduleViewController.h"
#import "CourseEventCell.h"
#import "MSEvent.h"
#import "MSGridline.h"
#import "ScheduleRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "NSDate+Week.h"
#import "CollectionViewScheduleLayout.h"
#import "XujcAPI.h"
#import "LoginViewController.h"
#import "XujcTerm.h"
#import "XujcCourse.h"
#import "DynamicData.h"

#import "ScheduleColumnHeader.h"

static NSString * const kCourseEventCellIdentifier = @"kCourseEventCellIdentifier";
static NSString * const kScheduleColumnHeaderReuseIdentifier = @"ScheduleColumnHeaderReuseIdentifier";
static NSString * const kScheduleRowHeaderReuseIdentifier = @"ScheduleRowHeaderReuseIdentifier";

@interface ScheduleViewController ()<MSCollectionViewDelegateCalendarLayout>

@property(nonatomic, strong) CollectionViewScheduleLayout *collectionViewCalendarLayout;
@property(nonatomic, strong) NSMutableArray *courseEvents;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionViewCalendarLayout = [[CollectionViewScheduleLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    self.collectionViewCalendarLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
    _courseEvents = [NSMutableArray arrayWithCapacity:kDayCountOfWeek];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupCollectionView];
    
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
    
    if (DYNAMIC_DATA.APIKey == nil){
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:NO completion:nil];
        return;
    }
    
    [self termRequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupCollectionView
{
    CGFloat navigationBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    CGFloat navigationBarBottomY = self.navigationController.navigationBar.frame.origin.y + navigationBarHeight;
    
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navigationBarBottomY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - navigationBarHeight - tabBarHeight)
                                         collectionViewLayout:self.collectionViewCalendarLayout];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    self.collectionView.bounces = NO;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:CourseEventCell.class forCellWithReuseIdentifier:kCourseEventCellIdentifier];
    [self.collectionView registerClass:ScheduleColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:kScheduleColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:ScheduleRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:kScheduleRowHeaderReuseIdentifier];
    
    [self.view addSubview:_collectionView];
    
    CGFloat width = CGRectGetWidth(_collectionView.bounds);
    CGFloat timeRowHeaderWidth = self.collectionViewCalendarLayout.timeRowHeaderWidth;
    //    CGFloat rightMargin = self.collectionViewCalendarLayout.contentMargin.right;
    CGFloat layoutSectionWidth = (width - timeRowHeaderWidth) / 4;
    
    self.collectionViewCalendarLayout.sectionWidth = layoutSectionWidth;

}

#pragma mark - UICollectionViewDataSource

/**
 *  @brief  获取课表列数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _courseEvents.count;
}
/**
 *  @brief  获取每天课程数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_courseEvents[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseEventCellIdentifier forIndexPath:indexPath];
    
    cell.event = [_courseEvents[indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        ScheduleColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kScheduleColumnHeaderReuseIdentifier forIndexPath:indexPath];
        
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.isCurrentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        ScheduleRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kScheduleRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewDelegateCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout dayForSection:(NSInteger)section
{
    return [[NSDate date] dayOfCurrentWeek:section + 1];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *dayOfCurrentWeek = [[NSDate date] dayOfCurrentWeek:indexPath.section];
    return [[_courseEvents[indexPath.section] objectAtIndex:indexPath.row] startTime:dayOfCurrentWeek];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *dayOfCurrentWeek = [[NSDate date] dayOfCurrentWeek:indexPath.section];
    return [[_courseEvents[indexPath.section] objectAtIndex:indexPath.row] endTime:dayOfCurrentWeek];
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout
{
    return [NSDate date];
}

#pragma mark - Requests

- (void)dataRequest
{
    
}

- (void)termRequest
{
    NSString *apiKey = DYNAMIC_DATA.APIKey;
    ResponseSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject){
        TyLogDebug(@"Success Response: %@", responseObject);
        NSArray *termIds = [responseObject allKeys];
        NSMutableArray *termArray = [NSMutableArray arrayWithCapacity:termIds.count];
        for (id key in termIds) {
            XujcTerm *term = [[XujcTerm alloc] init];
            term.termId = key;
            term.displayName = responseObject[key];
            [termArray addObject:term];
        }
        DYNAMIC_DATA.terms = termArray;
        [DYNAMIC_DATA flush];
        [self scheduleCourseRequest:[[DYNAMIC_DATA.terms lastObject] termId]];
    };
    ResponseFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        TyLogFatal(@"Failure:\n\tstatusCode: %ld,\n\tdetail: %@", operation.response.statusCode, error);
    };
    
    [XujcAPI terms:apiKey successBlock:success failureBlock:failure];
}

- (void)scheduleCourseRequest:(NSString *)termId
{
    NSString *apiKey = DYNAMIC_DATA.APIKey;
    ResponseSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject){
        TyLogDebug(@"Success Response: %@", responseObject);
        
        NSMutableArray *courseEventArray = [NSMutableArray arrayWithCapacity:[responseObject count]];
        
        for (id item in responseObject) {
            XujcCourse *course = [[XujcCourse alloc] initWithJSONResopnse:item];
            for (XujcCourseEvent* event in course.courseEvents) {
                [courseEventArray addObject:event];
            }
        }
        
        [_courseEvents removeAllObjects];
        
        for (NSInteger i = 0; i < kDayCountOfWeek; ++i) {
            [_courseEvents addObject:[ScheduleViewController coureEventsFromDayNumberOfWeek:courseEventArray dayNumberOfWeek:i + 1]];
        }
        [self.collectionViewCalendarLayout invalidateLayoutCache];
        [self.collectionView reloadData];
    };
    ResponseFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        TyLogFatal(@"Failure:\n\tstatusCode: %ld,\n\tdetail: %@", operation.response.statusCode, error);
    };
    [XujcAPI classSchedule:apiKey termId:@"20131" successBlock:success failureBlock:failure];
//    [XujcAPI classSchedule:apiKey termId:termId successBlock:success failureBlock:failure];
}

#pragma mark - Helper

+ (NSArray *)coureEventsFromDayNumberOfWeek:(NSArray *)allCourseEvents dayNumberOfWeek:(NSInteger)dayNumberOfWeek
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
