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

static NSString * const kTableCellReuseIdentifier = @"TableCellReuseIdentifier";

static NSString * const kCourseEventCellIdentifier = @"CourseEventCellIdentifier";
static NSString * const kScheduleColumnHeaderReuseIdentifier = @"ScheduleColumnHeaderReuseIdentifier";
static NSString * const kScheduleRowHeaderReuseIdentifier = @"ScheduleRowHeaderReuseIdentifier";

@interface ScheduleViewController ()<MSCollectionViewDelegateCalendarLayout, UICollectionViewDataSource>

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
    
    [self setupCollectionView];
}

- (void)bindViewModel
{
    [self.viewModel.termSelectorViewModel.selectedTermIdSignal subscribeNext:^(id x) {
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
    }];
}

#pragma mark - Setup

- (void)setupCollectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewCalendarLayout];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    self.collectionView.bounces = NO;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:CourseEventCell.class forCellWithReuseIdentifier:kCourseEventCellIdentifier];
    [self.collectionView registerClass:ScheduleColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:kScheduleColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:ScheduleRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:kScheduleRowHeaderReuseIdentifier];
    
    [self.view addSubview:_collectionView];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
    CGFloat width = SCREEN_SIZE.width;
    CGFloat timeRowHeaderWidth = self.collectionViewCalendarLayout.timeRowHeaderWidth;
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
    TyLogDebug(@"当前时间: %@", [NSDate date]);
    return [NSDate date];
}

@end
