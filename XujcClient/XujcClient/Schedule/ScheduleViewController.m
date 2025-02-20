/**
 * @file ScheduleViewController.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "ScheduleViewController.h"
#import "LessonEventCell.h"
#import "MSEvent.h"
#import "MSGridline.h"
#import "ScheduleRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "NSDate+Week.h"
#import "CollectionViewScheduleLayout.h"
#import "XujcSemesterModel.h"
#import "XujcLessonModel.h"
#import "DynamicData.h"
#import "ScheduleColumnHeader.h"
#import "LessonEventPopView.h"

static NSUInteger const kSectionCountOneScreen = 3;

static NSString * const kTableCellReuseIdentifier = @"TableCellReuseIdentifier";

static NSString * const kLessonEventCellIdentifier = @"LessonEventCellIdentifier";
static NSString * const kScheduleColumnHeaderReuseIdentifier = @"ScheduleColumnHeaderReuseIdentifier";
static NSString * const kScheduleRowHeaderReuseIdentifier = @"ScheduleRowHeaderReuseIdentifier";

@interface ScheduleViewController ()<MSCollectionViewDelegateCalendarLayout, UICollectionViewDataSource, UICollectionViewDelegate>

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
    self.screenName = @"Schedule Screen";
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
    [self.viewModel.semesterSelectorViewModel.selectedSemesterIdSignal subscribeNext:^(id x) {
        [self.viewModel.fetchScheduleLessonSignal subscribeNext:^(id x) {
            [self.collectionViewCalendarLayout invalidateLayoutCache];
            [self.collectionView reloadData];
        } error:^(NSError *error) {
            [self.collectionViewCalendarLayout invalidateLayoutCache];
            [self.collectionView reloadData];
            
            MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hub.detailsLabelText = error.localizedDescription;
            [hub hide:YES afterDelay:kErrorHUDShowTime];
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
    
    [self.collectionView registerClass:LessonEventCell.class forCellWithReuseIdentifier:kLessonEventCellIdentifier];
    [self.collectionView registerClass:ScheduleColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:kScheduleColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:ScheduleRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:kScheduleRowHeaderReuseIdentifier];
    
    [self.view addSubview:_collectionView];
    
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
    CGFloat width = SCREEN_SIZE.width;
    CGFloat timeRowHeaderWidth = self.collectionViewCalendarLayout.timeRowHeaderWidth;
    CGFloat layoutSectionWidth = (width - timeRowHeaderWidth) / kSectionCountOneScreen;
    self.collectionViewCalendarLayout.sectionWidth = layoutSectionWidth;

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kDayCountOfWeek;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfLessonEventInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LessonEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLessonEventCellIdentifier forIndexPath:indexPath];
    cell.viewModel = [self.viewModel cellViewModelAtIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        ScheduleColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kScheduleColumnHeaderReuseIdentifier forIndexPath:indexPath];
        
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        
        NSInteger currentChineseDayOfWeek = [NSDate currentChineseDayOfWeek];
        
        dayColumnHeader.day = day;
        dayColumnHeader.isCurrentDay = indexPath.section == (currentChineseDayOfWeek - 1);
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        ScheduleRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kScheduleRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.classSection = [self.collectionViewCalendarLayout classSectionForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat contentOffsetX = targetContentOffset->x;
    CGFloat sectionWidth_2 = self.collectionViewCalendarLayout.sectionWidth / 2.f;
    CGFloat offset = fmodf(contentOffsetX, self.collectionViewCalendarLayout.sectionWidth);
    NSInteger sectionIndex = contentOffsetX / self.collectionViewCalendarLayout.sectionWidth;
    
    if (offset < sectionWidth_2) {
        targetContentOffset->x = sectionIndex * self.collectionViewCalendarLayout.sectionWidth;
    } else if (offset > self.collectionViewCalendarLayout.sectionWidth - sectionWidth_2) {
        targetContentOffset->x = (sectionIndex + 1) * self.collectionViewCalendarLayout.sectionWidth;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LessonEventPopView *popView = [[LessonEventPopView alloc] initWithViewModel:[self.viewModel lessonEventPopViewModelAtIndexPath:indexPath]];
    
    @weakify(self);
    popView.hideCompletionBlock = ^(MMPopupView *view, BOOL completion) {
        @strongify(self);
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    };
    
    [popView show];
    TyLogDebug(@"selected %@", indexPath);
}

#pragma mark - MSCollectionViewDelegateCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout dayForSection:(NSInteger)section
{
    return [[NSDate date] dayOfCurrentWeek:section + 1];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout startClassSectionIndexForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.viewModel.lessonEvents[indexPath.section] objectAtIndex:indexPath.row] startSection] sectionIndex];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout endClassSectionIndexForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[self.viewModel.lessonEvents[indexPath.section] objectAtIndex:indexPath.row] endSection] sectionIndex];
}

- (NSDate *)currentTimeForCollectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout
{
    return [NSDate date];
}

@end
