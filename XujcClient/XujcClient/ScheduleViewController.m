/**
 * @file ScheduleViewController.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "ScheduleViewController.h"
#import "MSEventCell.h"
#import "MSEvent.h"
#import "MSGridline.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "NSDate+CupertinoYankee.h"
#import <MSCollectionViewCalendarLayout.h>

static NSInteger const kDayCountOfWeek = 7;
static NSInteger const kTimeIntervalOfDay = 60 * 60 * 24;

static NSString * const kMSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
static NSString * const kMSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
static NSString * const kMSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

@interface ScheduleViewController ()<MSCollectionViewDelegateCalendarLayout>

@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (nonatomic, readonly) CGFloat layoutSectionWidth;

@end

@implementation ScheduleViewController

- (id)init
{
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    self = [super initWithCollectionViewLayout:self.collectionViewCalendarLayout];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:kMSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:kMSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:kMSTimeRowHeaderReuseIdentifier];
    
    self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
//    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"start" ascending:YES]];
//    // No events with undecided times or dates
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(dateToBeDecided == NO) AND (timeToBeDecided == NO)"];
//    // Divide into sections by the "day" key path
//    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:@"day" cacheName:nil];
//    self.fetchedResultsController.delegate = self;
//    [self.fetchedResultsController performFetch:nil];
    
//    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kDayCountOfWeek;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [(id <NSFetchedResultsSectionInfo>)self.fetchedResultsController.sections[section] numberOfObjects];
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSEventCellReuseIdentifier forIndexPath:indexPath];
    MSEvent *event = [[MSEvent alloc] init];
//    event.remoteID = @(100);
    event.start = [NSDate dateWithTimeIntervalSinceNow:-100];
    event.title = @"title";
    event.location = @"location";
//    event.timeToBeDecided = @(1);
//    event.dateToBeDecided = @(2);
    
    cell.event = event;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewDelegateCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout dayForSection:(NSInteger)section
{
    NSDate *now = [NSDate date];
    NSDate *beginningOfWeek = [now beginningOfWeek];
    TyLogDebug(@"beginningOfWeek: %@", beginningOfWeek);
    return [beginningOfWeek dateByAddingTimeInterval:kTimeIntervalOfDay];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [NSDate date];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return [[NSDate date] dateByAddingTimeInterval:(60 * 60 * 3)];
    return [NSDate date];
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout
{
    return [NSDate date];
}

#pragma mark - Getter

- (CGFloat)layoutSectionWidth
{
    // Default to 254 on iPad.
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 254.0;
    //    }
    
    //    // Otherwise, on iPhone, fit-to-width.
    //    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    //    CGFloat timeRowHeaderWidth = self.collectionViewCalendarLayout.timeRowHeaderWidth;
    //    CGFloat rightMargin = self.collectionViewCalendarLayout.contentMargin.right;
    //
    //    return (width - timeRowHeaderWidth - rightMargin);
//    return 100;
}


@end
