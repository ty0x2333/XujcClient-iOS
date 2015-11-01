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
#import "ScheduleRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "NSDate+CupertinoYankee.h"
#import <MSCollectionViewCalendarLayout.h>
#import "XujcAPI.h"
#import "LoginViewController.h"
#import "XujcTerm.h"
#import "DynamicData.h"

#import "ScheduleColumnHeader.h"

static NSInteger const kDayCountOfWeek = 7;
static NSInteger const kTimeIntervalOfDay = 60 * 60 * 24;
static NSInteger const kTimeIntervalOfHour = 60 * 60;
static NSInteger const kTimeIntervalOfMinute = 60;

static NSString * const kMSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
static NSString * const kScheduleColumnHeaderReuseIdentifier = @"ScheduleColumnHeaderReuseIdentifier";
static NSString * const kScheduleRowHeaderReuseIdentifier = @"ScheduleRowHeaderReuseIdentifier";

static CGFloat const kTimeRowHeaderWidth = 40.0f;

@interface ScheduleViewController ()<MSCollectionViewDelegateCalendarLayout>

@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (nonatomic, readonly) CGFloat layoutSectionWidth;

@end

@implementation ScheduleViewController

- (id)init
{
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    self.collectionViewCalendarLayout.timeRowHeaderWidth = kTimeRowHeaderWidth;
    self.collectionViewCalendarLayout.currentTimeIndicatorSize = CGSizeMake(self.collectionViewCalendarLayout.timeRowHeaderWidth, 10.0);
//    self.collectionViewCalendarLayout.hourHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80.0 : 80.0);
//    self.collectionViewCalendarLayout.sectionWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 194.0 : 254.0);
//    self.collectionViewCalendarLayout.dayColumnHeaderHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60.0 : 50.0);
//    self.collectionViewCalendarLayout.currentTimeHorizontalGridlineHeight = 1.0;
//    self.collectionViewCalendarLayout.verticalGridlineWidth = (([[UIScreen mainScreen] scale] == 2.0) ? 0.5 : 1.0);
//    self.collectionViewCalendarLayout.horizontalGridlineHeight = (([[UIScreen mainScreen] scale] == 2.0) ? 0.5 : 1.0);;
//    self.collectionViewCalendarLayout.sectionMargin = UIEdgeInsetsMake(30.0, 0.0, 30.0, 0.0);
//    self.collectionViewCalendarLayout.cellMargin = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
//    self.collectionViewCalendarLayout.contentMargin = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIEdgeInsetsMake(30.0, 0.0, 30.0, 30.0) : UIEdgeInsetsMake(20.0, 0.0, 20.0, 10.0));
    
    self.collectionViewCalendarLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;

    self = [super initWithCollectionViewLayout:self.collectionViewCalendarLayout];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:kMSEventCellReuseIdentifier];
    [self.collectionView registerClass:ScheduleColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:kScheduleColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:ScheduleRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:kScheduleRowHeaderReuseIdentifier];
    
    self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMSEventCellReuseIdentifier forIndexPath:indexPath];
    MSEvent *event = [[MSEvent alloc] init];
    event.start = [NSDate dateWithTimeIntervalSinceNow:-100];
    event.title = @"title";
    event.location = @"location";
    
    cell.event = event;
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

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout dayForSection:(NSInteger)section
{
    NSDate *now = [NSDate date];
    NSDate *beginningOfWeek = [now beginningOfWeek];
//    TyLogDebug(@"beginningOfWeek: %@", beginningOfWeek);
    return [beginningOfWeek dateByAddingTimeInterval:section * kTimeIntervalOfDay];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[NSDate date] beginningOfDay] dateByAddingTimeInterval:kTimeIntervalOfHour * 8];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[NSDate date] beginningOfDay] dateByAddingTimeInterval:kTimeIntervalOfHour * 10 + kTimeIntervalOfMinute * 25];
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout
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
    };
    ResponseFailureBlock failure = ^(AFHTTPRequestOperation *operation, NSError *error) {
        TyLogFatal(@"Failure:\n\tstatusCode: %ld,\n\tdetail: %@", operation.response.statusCode, error);
    };
    
    [XujcAPI terms:apiKey successBlock:success failureBlock:failure];
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
