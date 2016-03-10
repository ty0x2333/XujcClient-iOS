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
#import "XujcTerm.h"
#import "XujcCourse.h"
#import "DynamicData.h"

#import "ScheduleColumnHeader.h"

static NSString * const kCourseEventCellIdentifier = @"kCourseEventCellIdentifier";
static NSString * const kScheduleColumnHeaderReuseIdentifier = @"ScheduleColumnHeaderReuseIdentifier";
static NSString * const kScheduleRowHeaderReuseIdentifier = @"ScheduleRowHeaderReuseIdentifier";

@interface ScheduleViewController ()<MSCollectionViewDelegateCalendarLayout>

@property (strong, nonatomic) ScheduleViewModel *viewModel;

@property(nonatomic, strong) CollectionViewScheduleLayout *collectionViewCalendarLayout;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ScheduleViewController

- (instancetype)initWithViewModel:(ScheduleViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionViewCalendarLayout = [[CollectionViewScheduleLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
    [self bindViewModel];
}

- (void)bindViewModel
{
    @weakify(self);
    [_viewModel.fetchTermsSignal subscribeNext:^(id x) {
        @strongify(self);
        TyLogDebug(@"fetchTerms success");
        [self.viewModel.fetchScheduleCourseSignal subscribeNext:^(id x) {
            [self.collectionViewCalendarLayout invalidateLayoutCache];
            [self.collectionView reloadData];
            TyLogDebug(@"fetchScheduleSuccess success");
        } error:^(NSError *error) {
            MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.detailsLabelText = error.localizedDescription;
            [hub hide:YES afterDelay:kErrorHUDShowTime];
            TyLogDebug(@"fetchScheduleCourse error");
        }];
    } error:^(NSError *error) {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.detailsLabelText = error.localizedDescription;
        [hub hide:YES afterDelay:kErrorHUDShowTime];
        TyLogDebug(@"fetchTerms error");
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupCollectionView];
    
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
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
    
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navigationBarBottomY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - navigationBarHeight - tabBarHeight - statusBarHeight)
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kDayCountOfWeek;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfCourseEventInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCourseEventCellIdentifier forIndexPath:indexPath];
    cell.viewModel = [self.viewModel cellViewModelAtIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        ScheduleColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kScheduleColumnHeaderReuseIdentifier forIndexPath:indexPath];
        
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        
        NSDate *currentDay = [self currentTimeForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.isCurrentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        ScheduleRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kScheduleRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.classSection = [self.collectionViewCalendarLayout classSectionForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewDelegateCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout dayForSection:(NSInteger)section
{
    return [[NSDate date] dayOfCurrentWeek:section + 1];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout startClassSectionIndexForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.viewModel.courseEvents[indexPath.section] objectAtIndex:indexPath.row] startSection] sectionIndex];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout endClassSectionIndexForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.viewModel.courseEvents[indexPath.section] objectAtIndex:indexPath.row] endSection] sectionIndex];
}

- (NSDate *)currentTimeForCollectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout
{
    return [NSDate date];
}

@end
