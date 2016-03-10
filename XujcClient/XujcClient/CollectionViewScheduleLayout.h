/**
 * @file CollectionViewScheduleLayout.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "XujcSection.h"

extern NSString * const MSCollectionElementKindTimeRowHeader;
extern NSString * const MSCollectionElementKindDayColumnHeader;
extern NSString * const MSCollectionElementKindTimeRowHeaderBackground;
extern NSString * const MSCollectionElementKindDayColumnHeaderBackground;
extern NSString * const MSCollectionElementKindCurrentTimeIndicator;
extern NSString * const MSCollectionElementKindCurrentTimeHorizontalGridline;
extern NSString * const MSCollectionElementKindVerticalGridline;
extern NSString * const MSCollectionElementKindHorizontalGridline;

typedef NS_ENUM(NSUInteger, MSHeaderLayoutType) {
    MSHeaderLayoutTypeTimeRowAboveDayColumn,
    MSHeaderLayoutTypeDayColumnAboveTimeRow
};

@class CollectionViewScheduleLayout;
@protocol MSCollectionViewDelegateCalendarLayout;

@interface CollectionViewScheduleLayout : UICollectionViewLayout

@property (nonatomic, weak) id <MSCollectionViewDelegateCalendarLayout> delegate;

@property (nonatomic) CGFloat classSectionHeight;

@property (nonatomic) CGFloat sectionWidth;
@property (nonatomic) CGFloat dayColumnHeaderHeight;
@property (nonatomic) CGFloat timeRowHeaderWidth;
@property (nonatomic) CGSize currentTimeIndicatorSize;
@property (nonatomic) CGFloat horizontalGridlineHeight;
@property (nonatomic) CGFloat verticalGridlineWidth;
@property (nonatomic) CGFloat currentTimeHorizontalGridlineHeight;
@property (nonatomic) UIEdgeInsets contentMargin;
@property (nonatomic) UIEdgeInsets cellMargin;
@property (nonatomic) MSHeaderLayoutType headerLayoutType;
@property (nonatomic) BOOL displayHeaderBackgroundAtOrigin;

/**
 *  @brief  获取行头的课程节号
 */
- (XujcSection *)classSectionForTimeRowHeaderAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForDayColumnHeaderAtIndexPath:(NSIndexPath *)indexPath;

- (void)scrollCollectionViewToClosetSectionToCurrentTimeAnimated:(BOOL)animated;

// Since a "reloadData" on the UICollectionView doesn't call "prepareForCollectionViewUpdates:", this method must be called first to flush the internal caches
- (void)invalidateLayoutCache;

@end

@protocol MSCollectionViewDelegateCalendarLayout <UICollectionViewDelegate>

@required
/**
 *  @brief  列表标题时间
 *
 *  @param collectionView       collectionView
 *  @param collectionViewLayout collectionViewLayout
 *  @param section              列号
 *
 *  @return 该列显示的NSDate
 */
- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout dayForSection:(NSInteger)section;
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout startClassSectionIndexForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout endClassSectionIndexForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)currentTimeForCollectionView:(UICollectionView *)collectionView layout:(CollectionViewScheduleLayout *)collectionViewLayout;

@end
