/**
 * @file CollectionViewScheduleLayout.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/11/2
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */
#import "CollectionViewScheduleLayout.h"
#import <CupertinoYankee/NSDate+CupertinoYankee.h>

NSString * const MSCollectionElementKindTimeRowHeader = @"MSCollectionElementKindTimeRow";
NSString * const MSCollectionElementKindDayColumnHeader = @"MSCollectionElementKindDayHeader";
NSString * const MSCollectionElementKindTimeRowHeaderBackground = @"MSCollectionElementKindTimeRowHeaderBackground";
NSString * const MSCollectionElementKindDayColumnHeaderBackground = @"MSCollectionElementKindDayColumnHeaderBackground";
NSString * const MSCollectionElementKindCurrentTimeIndicator = @"MSCollectionElementKindCurrentTimeIndicator";
NSString * const MSCollectionElementKindCurrentTimeHorizontalGridline = @"MSCollectionElementKindCurrentTimeHorizontalGridline";
NSString * const MSCollectionElementKindVerticalGridline = @"MSCollectionElementKindVerticalGridline";
NSString * const MSCollectionElementKindHorizontalGridline = @"MSCollectionElementKindHorizontalGridline";

NSUInteger const MSCollectionMinOverlayZ = 1000.0; // Allows for 900 items in a section without z overlap issues
NSUInteger const MSCollectionMinCellZ = 100.0;  // Allows for 100 items in a section's background
NSUInteger const MSCollectionMinBackgroundZ = 0.0;

static CGFloat const kTimeRowHeaderWidth = 40.0f;

@interface MSTimerWeakTarget : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
- (SEL)fireSelector;
@end

@implementation MSTimerWeakTarget
- (id)initWithTarget:(id)target selector:(SEL)selector
{
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
    }
    return self;
}
- (void)fire:(NSTimer*)timer
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.selector withObject:timer];
#pragma clang diagnostic pop
}
- (SEL)fireSelector
{
    return @selector(fire:);
}
@end

@interface CollectionViewScheduleLayout ()

// Minute Timer
@property (nonatomic, strong) NSTimer *minuteTimer;

// Minute Height
@property (nonatomic, readonly) CGFloat minuteHeight;

// Caches
@property (nonatomic, assign) BOOL needsToPopulateAttributesForAllSections;
@property (nonatomic, strong) NSCache *cachedDayDateComponents;
@property (nonatomic, strong) NSCache *cachedStartClassSectionComponents;
@property (nonatomic, strong) NSCache *cachedEndClassSectionComponents;
@property (nonatomic, strong) NSCache *cachedCurrentDateComponents;
@property (nonatomic, assign) CGFloat cachedMaxColumnHeight;

@property (nonatomic, assign) NSInteger cachedEarliestClassSection;
@property (nonatomic, assign) NSInteger cachedLatestClassSection;

@property (nonatomic, strong) NSMutableDictionary *cachedColumnHeights;
@property (nonatomic, strong) NSMutableDictionary *cachedEarliestClassSectionIndexs;
@property (nonatomic, strong) NSMutableDictionary *cachedLatestClassSectionIndexs;

// Registered Decoration Classes
@property (nonatomic, strong) NSMutableDictionary *registeredDecorationClasses;

// Attributes
@property (nonatomic, strong) NSMutableArray *allAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemAttributes;
@property (nonatomic, strong) NSMutableDictionary *dayColumnHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *dayColumnHeaderBackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *timeRowHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *timeRowHeaderBackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *horizontalGridlineAttributes;
@property (nonatomic, strong) NSMutableDictionary *verticalGridlineAttributes;
@property (nonatomic, strong) NSMutableDictionary *currentTimeIndicatorAttributes;
@property (nonatomic, strong) NSMutableDictionary *currentTimeHorizontalGridlineAttributes;

- (void)initialize;
// Minute Updates
- (void)minuteTick:(id)sender;
// Layout
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache;
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache;
- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache;
// Scrolling
- (NSInteger)closestSectionToCurrentTime;
// Section Sizing
- (CGRect)rectForSection:(NSInteger)section;
- (CGFloat)maxSectionHeight;
- (CGFloat)stackedSectionHeight;
- (CGFloat)stackedSectionHeightUpToSection:(NSInteger)upToSection;
- (CGFloat)sectionHeight:(NSInteger)section;
- (CGFloat)minuteHeight;
// Z Index
- (CGFloat)zIndexForElementKind:(NSString *)elementKind;
- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating;
// Hours
/**
 *  @brief  最早课程节数
 */
- (NSInteger)earliestClassSection;
- (NSInteger)latestClassSection;
- (NSInteger)earliestClassSectionForSection:(NSInteger)section;
- (NSInteger)latestClassSectionForSection:(NSInteger)section;
// Delegate Wrappers
- (NSDateComponents *)dayForSection:(NSInteger)section;
- (NSInteger)startClassSectionIndexForIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)endClassSectionIndexForIndexPath:(NSIndexPath *)indexPath;
- (NSDateComponents *)currentTimeDateComponents;

@end

@implementation CollectionViewScheduleLayout

#pragma mark - NSObject

- (void)dealloc
{
    [self.minuteTimer invalidate];
    self.minuteTimer = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [self invalidateLayoutCache];
    
    // Update the layout with the new items
    [self prepareLayout];
    
    [super prepareForCollectionViewUpdates:updateItems];
}

- (void)finalizeCollectionViewUpdates
{
    // This is a hack to prevent the error detailed in :
    // http://stackoverflow.com/questions/12857301/uicollectionview-decoration-and-supplementary-views-can-not-be-moved
    // If this doesn't happen, whenever the collection view has batch updates performed on it, we get multiple instantiations of decoration classes
    for (UIView *subview in self.collectionView.subviews) {
        for (Class decorationViewClass in self.registeredDecorationClasses.allValues) {
            if ([subview isKindOfClass:decorationViewClass]) {
                [subview removeFromSuperview];
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)decorationViewKind
{
    [super registerClass:viewClass forDecorationViewOfKind:decorationViewKind];
    self.registeredDecorationClasses[decorationViewKind] = viewClass;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (self.needsToPopulateAttributesForAllSections) {
        [self prepareSectionLayoutForSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
        self.needsToPopulateAttributesForAllSections = NO;
    }
    
    BOOL needsToPopulateAllAttribtues = (self.allAttributes.count == 0);
    if (needsToPopulateAllAttribtues) {
        [self.allAttributes addObjectsFromArray:[self.dayColumnHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.dayColumnHeaderBackgroundAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.timeRowHeaderAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.timeRowHeaderBackgroundAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.verticalGridlineAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.horizontalGridlineAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.itemAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.currentTimeIndicatorAttributes allValues]];
        [self.allAttributes addObjectsFromArray:[self.currentTimeHorizontalGridlineAttributes allValues]];
    }
}

- (void)prepareSectionLayoutForSections:(NSIndexSet *)sectionIndexes
{
    if (self.collectionView.numberOfSections == 0) {
        return;
    }
    
    BOOL needsToPopulateItemAttributes = (self.itemAttributes.count == 0);
    BOOL needsToPopulateVerticalGridlineAttributes = (self.verticalGridlineAttributes.count == 0);
    
    NSInteger earliestClassSectionIndex = [self earliestClassSection];
    NSInteger latestClassSectionIndex = [self latestClassSection];
    
    CGFloat sectionWidth = (self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right);
    CGFloat sectionHeight = nearbyintf((_classSectionHeight * (latestClassSectionIndex - earliestClassSectionIndex)) + (self.sectionMargin.top + self.sectionMargin.bottom));
    CGFloat calendarGridMinX = (self.timeRowHeaderWidth + self.contentMargin.left);
    CGFloat calendarGridMinY = (self.dayColumnHeaderHeight + self.contentMargin.top);
    CGFloat calendarContentMinX = (self.timeRowHeaderWidth + self.contentMargin.left + self.sectionMargin.left);
    CGFloat calendarContentMinY = (self.dayColumnHeaderHeight + self.contentMargin.top + self.sectionMargin.top);
    CGFloat calendarGridWidth = (self.collectionViewContentSize.width - self.timeRowHeaderWidth - self.contentMargin.right);
    
    // Time Row Header
    CGFloat timeRowHeaderMinX = fmaxf(self.collectionView.contentOffset.x, 0.0);
    BOOL timeRowHeaderFloating = ((timeRowHeaderMinX != 0) || self.displayHeaderBackgroundAtOrigin);;
    
    // Time Row Header Background
    NSIndexPath *timeRowHeaderBackgroundIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *timeRowHeaderBackgroundAttributes = [self layoutAttributesForDecorationViewAtIndexPath:timeRowHeaderBackgroundIndexPath ofKind:MSCollectionElementKindTimeRowHeaderBackground withItemCache:self.timeRowHeaderBackgroundAttributes];
    // Frame
    CGFloat timeRowHeaderBackgroundHeight = self.collectionView.frame.size.height;
    CGFloat timeRowHeaderBackgroundWidth = self.collectionView.frame.size.width;
    CGFloat timeRowHeaderBackgroundMinX = (timeRowHeaderMinX - timeRowHeaderBackgroundWidth + self.timeRowHeaderWidth);
    CGFloat timeRowHeaderBackgroundMinY = self.collectionView.contentOffset.y;
    timeRowHeaderBackgroundAttributes.frame = CGRectMake(timeRowHeaderBackgroundMinX, timeRowHeaderBackgroundMinY, timeRowHeaderBackgroundWidth, timeRowHeaderBackgroundHeight);
    
    // Floating
    timeRowHeaderBackgroundAttributes.hidden = !timeRowHeaderFloating;
    timeRowHeaderBackgroundAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindTimeRowHeaderBackground floating:timeRowHeaderFloating];
    
    // Current Time Indicator
    NSIndexPath *currentTimeIndicatorIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *currentTimeIndicatorAttributes = [self layoutAttributesForDecorationViewAtIndexPath:currentTimeIndicatorIndexPath ofKind:MSCollectionElementKindCurrentTimeIndicator withItemCache:self.currentTimeIndicatorAttributes];
    
    // Current Time Horizontal Gridline
    NSIndexPath *currentTimeHorizontalGridlineIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *currentTimeHorizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:currentTimeHorizontalGridlineIndexPath ofKind:MSCollectionElementKindCurrentTimeHorizontalGridline withItemCache:self.currentTimeHorizontalGridlineAttributes];
    
    // The current time is within the day
    XujcSection *earliestClassSection = [XujcSection sectionIndex:earliestClassSectionIndex];
    XujcSection *latestClassSection = [XujcSection sectionIndex:latestClassSectionIndex];
    NSDateComponents *currentTimeDateComponents = [self currentTimeDateComponents];
    NSDate *currentTimeDate = currentTimeDateComponents.date;
    
    BOOL currentTimeIndicatorVisible = ([currentTimeDate earlierDate:latestClassSection.endTime] && [currentTimeDate laterDate:earliestClassSection.startTime]);
    currentTimeIndicatorAttributes.hidden = !currentTimeIndicatorVisible;
    currentTimeHorizontalGridlineAttributes.hidden = !currentTimeIndicatorVisible;
    
    if (currentTimeIndicatorVisible) {
#warning message
        // The y value of the current time
//        CGFloat timeY = (calendarContentMinY + nearbyintf(((currentTimeDateComponents.hour - earliestHour) * _classSectionHeight) + (currentTimeDateComponents.minute * self.minuteHeight)));
//
//        CGFloat currentTimeIndicatorMinY = (timeY - nearbyintf(self.currentTimeIndicatorSize.height / 2.0));
//        CGFloat currentTimeIndicatorMinX = (fmaxf(self.collectionView.contentOffset.x, 0.0) + (self.timeRowHeaderWidth - self.currentTimeIndicatorSize.width));
//        currentTimeIndicatorAttributes.frame = (CGRect){{currentTimeIndicatorMinX, currentTimeIndicatorMinY}, self.currentTimeIndicatorSize};
//        currentTimeIndicatorAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindCurrentTimeIndicator floating:timeRowHeaderFloating];
//        
//        CGFloat currentTimeHorizontalGridlineMinY = (timeY - nearbyintf(self.currentTimeHorizontalGridlineHeight / 2.0));
//        CGFloat currentTimeHorizontalGridlineXOffset = (calendarGridMinX + self.sectionMargin.left);
//        CGFloat currentTimeHorizontalGridlineMinX = fmaxf(currentTimeHorizontalGridlineXOffset, self.collectionView.contentOffset.x + currentTimeHorizontalGridlineXOffset);
//        CGFloat currentTimehorizontalGridlineWidth = fminf(calendarGridWidth, self.collectionView.frame.size.width);
//        currentTimeHorizontalGridlineAttributes.frame = CGRectMake(currentTimeHorizontalGridlineMinX, currentTimeHorizontalGridlineMinY, currentTimehorizontalGridlineWidth, self.currentTimeHorizontalGridlineHeight);
//        currentTimeHorizontalGridlineAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    }
    
    // Day Column Header
    CGFloat dayColumnHeaderMinY = fmaxf(self.collectionView.contentOffset.y, 0.0);
    BOOL dayColumnHeaderFloating = ((dayColumnHeaderMinY != 0) || self.displayHeaderBackgroundAtOrigin);
    
    // Day Column Header Background
    NSIndexPath *dayColumnHeaderBackgroundIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *dayColumnHeaderBackgroundAttributes = [self layoutAttributesForDecorationViewAtIndexPath:dayColumnHeaderBackgroundIndexPath ofKind:MSCollectionElementKindDayColumnHeaderBackground withItemCache:self.dayColumnHeaderBackgroundAttributes];
    // Frame
    CGFloat dayColumnHeaderBackgroundHeight = (self.dayColumnHeaderHeight + ((self.collectionView.contentOffset.y < 0.0) ? ABS(self.collectionView.contentOffset.y) : 0.0));
    dayColumnHeaderBackgroundAttributes.frame = (CGRect){self.collectionView.contentOffset, {self.collectionView.frame.size.width, dayColumnHeaderBackgroundHeight}};
    // Floating
    dayColumnHeaderBackgroundAttributes.hidden = !dayColumnHeaderFloating;
    dayColumnHeaderBackgroundAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindDayColumnHeaderBackground floating:dayColumnHeaderFloating];
    
    // Time Row Headers
    NSUInteger timeRowHeaderIndex = 0;
    for (NSInteger index = earliestClassSectionIndex; index <= latestClassSectionIndex; index++) {
        NSIndexPath *timeRowHeaderIndexPath = [NSIndexPath indexPathForItem:timeRowHeaderIndex inSection:0];
        UICollectionViewLayoutAttributes *timeRowHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:timeRowHeaderIndexPath ofKind:MSCollectionElementKindTimeRowHeader withItemCache:self.timeRowHeaderAttributes];
        CGFloat titleRowHeaderMinY = (calendarContentMinY + (_classSectionHeight * (index - earliestClassSectionIndex)));
        timeRowHeaderAttributes.frame = CGRectMake(timeRowHeaderMinX, titleRowHeaderMinY, self.timeRowHeaderWidth, _classSectionHeight);
        timeRowHeaderAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindTimeRowHeader floating:timeRowHeaderFloating];
        timeRowHeaderIndex++;
    }
    
    [sectionIndexes enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        
        CGFloat sectionMinX = (calendarContentMinX + (sectionWidth * section));
        
        // Day Column Header
        UICollectionViewLayoutAttributes *dayColumnHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section] ofKind:MSCollectionElementKindDayColumnHeader withItemCache:self.dayColumnHeaderAttributes];
        dayColumnHeaderAttributes.frame = CGRectMake(sectionMinX, dayColumnHeaderMinY, self.sectionWidth, self.dayColumnHeaderHeight);
        dayColumnHeaderAttributes.zIndex = [self zIndexForElementKind:MSCollectionElementKindDayColumnHeader floating:dayColumnHeaderFloating];
        
        if (needsToPopulateVerticalGridlineAttributes) {
            // Vertical Gridline
            NSIndexPath *verticalGridlineIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:verticalGridlineIndexPath ofKind:MSCollectionElementKindVerticalGridline withItemCache:self.verticalGridlineAttributes];
            CGFloat horizontalGridlineMinX = nearbyintf(sectionMinX - self.sectionMargin.left - (self.verticalGridlineWidth / 2.0));
            horizontalGridlineAttributes.frame = CGRectMake(horizontalGridlineMinX, calendarGridMinY, self.verticalGridlineWidth, sectionHeight);
        }
        
        if (needsToPopulateItemAttributes) {
            // Items
            NSMutableArray *sectionItemAttributes = [NSMutableArray new];
            for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
                
                NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForCellAtIndexPath:itemIndexPath withItemCache:self.itemAttributes];
                [sectionItemAttributes addObject:itemAttributes];
                
                NSInteger itemStartClassSectionIndex = [self startClassSectionIndexForIndexPath:itemIndexPath];
                
                NSInteger itemClassSectionDuration = [self endClassSectionIndexForIndexPath:itemIndexPath] - itemStartClassSectionIndex + 1;
                
                CGFloat startClassSecionIndexY = ((itemStartClassSectionIndex - earliestClassSectionIndex) * _classSectionHeight);
                
                CGFloat endClassSecionIndexY = startClassSecionIndexY + itemClassSectionDuration * _classSectionHeight;
                
                CGFloat itemMinY = nearbyintf(startClassSecionIndexY + calendarContentMinY + self.cellMargin.top);
                CGFloat itemMaxY = nearbyintf(endClassSecionIndexY + calendarContentMinY - self.cellMargin.bottom);
                CGFloat itemMinX = nearbyintf(sectionMinX + self.cellMargin.left);
                CGFloat itemMaxX = nearbyintf(itemMinX + (self.sectionWidth - (self.cellMargin.left + self.cellMargin.right)));
                itemAttributes.frame = CGRectMake(itemMinX, itemMinY, (itemMaxX - itemMinX), (itemMaxY - itemMinY));
                
                itemAttributes.zIndex = [self zIndexForElementKind:nil];
            }
            [self adjustItemsForOverlap:sectionItemAttributes inSection:section sectionMinX:sectionMinX];
        }
    }];
    
    // Horizontal Gridlines
    NSUInteger horizontalGridlineIndex = 0;
    for (NSInteger index = earliestClassSectionIndex; index <= latestClassSectionIndex; index++) {
        NSIndexPath *horizontalGridlineIndexPath = [NSIndexPath indexPathForItem:horizontalGridlineIndex inSection:0];
        UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:horizontalGridlineIndexPath ofKind:MSCollectionElementKindHorizontalGridline withItemCache:self.horizontalGridlineAttributes];
        CGFloat horizontalGridlineMinY = nearbyintf(calendarContentMinY + (_classSectionHeight * (index - earliestClassSectionIndex))) - (self.horizontalGridlineHeight / 2.0);
        
        CGFloat horizontalGridlineXOffset = (calendarGridMinX + self.sectionMargin.left);
        CGFloat horizontalGridlineMinX = fmaxf(horizontalGridlineXOffset, self.collectionView.contentOffset.x + horizontalGridlineXOffset);
        CGFloat horizontalGridlineWidth = fminf(calendarGridWidth, self.collectionView.frame.size.width);
        horizontalGridlineAttributes.frame = CGRectMake(horizontalGridlineMinX, horizontalGridlineMinY, horizontalGridlineWidth, self.horizontalGridlineHeight);
        horizontalGridlineIndex++;
    }
}

- (void)adjustItemsForOverlap:(NSArray *)sectionItemAttributes inSection:(NSUInteger)section sectionMinX:(CGFloat)sectionMinX
{
    NSMutableSet *adjustedAttributes = [NSMutableSet new];
    NSUInteger sectionZ = MSCollectionMinCellZ;
    
    for (UICollectionViewLayoutAttributes *itemAttributes in sectionItemAttributes) {
        
        // If an item's already been adjusted, move on to the next one
        if ([adjustedAttributes containsObject:itemAttributes]) {
            continue;
        }
        
        // Find the other items that overlap with this item
        NSMutableArray *overlappingItems = [NSMutableArray new];
        CGRect itemFrame = itemAttributes.frame;
        [overlappingItems addObjectsFromArray:[sectionItemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
            if ((layoutAttributes != itemAttributes)) {
                return CGRectIntersectsRect(itemFrame, layoutAttributes.frame);
            } else {
                return NO;
            }
        }]]];
        
        // If there's items overlapping, we need to adjust them
        if (overlappingItems.count) {
            
            // Add the item we're adjusting to the overlap set
            [overlappingItems insertObject:itemAttributes atIndex:0];
            
            // Find the minY and maxY of the set
            CGFloat minY = CGFLOAT_MAX;
            CGFloat maxY = CGFLOAT_MIN;
            for (UICollectionViewLayoutAttributes *overlappingItemAttributes in overlappingItems) {
                if (CGRectGetMinY(overlappingItemAttributes.frame) < minY) {
                    minY = CGRectGetMinY(overlappingItemAttributes.frame);
                }
                if (CGRectGetMaxY(overlappingItemAttributes.frame) > maxY) {
                    maxY = CGRectGetMaxY(overlappingItemAttributes.frame);
                }
            }
            
            // Determine the number of divisions needed (maximum number of currently overlapping items)
            NSInteger divisions = 1;
            for (CGFloat currentY = minY; currentY <= maxY; currentY += 1.0) {
                NSInteger numberItemsForCurrentY = 0;
                for (UICollectionViewLayoutAttributes *overlappingItemAttributes in overlappingItems) {
                    if ((currentY >= CGRectGetMinY(overlappingItemAttributes.frame)) && (currentY < CGRectGetMaxY(overlappingItemAttributes.frame))) {
                        numberItemsForCurrentY++;
                    }
                }
                if (numberItemsForCurrentY > divisions) {
                    divisions = numberItemsForCurrentY;
                }
            }
            
            // Adjust the items to have a width of the section size divided by the number of divisions needed
            CGFloat divisionWidth = nearbyintf(self.sectionWidth / divisions);
            
            NSMutableArray *dividedAttributes = [NSMutableArray array];
            for (UICollectionViewLayoutAttributes *divisionAttributes in overlappingItems) {
                
                CGFloat itemWidth = (divisionWidth - self.cellMargin.left - self.cellMargin.right);
                
                // It it hasn't yet been adjusted, perform adjustment
                if (![adjustedAttributes containsObject:divisionAttributes]) {
                    
                    CGRect divisionAttributesFrame = divisionAttributes.frame;
                    divisionAttributesFrame.origin.x = (sectionMinX + self.cellMargin.left);
                    divisionAttributesFrame.size.width = itemWidth;
                    
                    // Horizontal Layout
                    NSInteger adjustments = 1;
                    for (UICollectionViewLayoutAttributes *dividedItemAttributes in dividedAttributes) {
                        if (CGRectIntersectsRect(dividedItemAttributes.frame, divisionAttributesFrame)) {
                            divisionAttributesFrame.origin.x = sectionMinX + ((divisionWidth * adjustments) + self.cellMargin.left);
                            adjustments++;
                        }
                    }
                    
                    // Stacking (lower items stack above higher items, since the title is at the top)
                    divisionAttributes.zIndex = sectionZ;
                    sectionZ ++;
                    
                    divisionAttributes.frame = divisionAttributesFrame;
                    [dividedAttributes addObject:divisionAttributes];
                    [adjustedAttributes addObject:divisionAttributes];
                }
            }
        }
    }
}
/**
 *  @brief  collectionView的内容的尺寸
 */
- (CGSize)collectionViewContentSize
{
    CGFloat width;
    CGFloat height;
    height = [self maxSectionHeight];
    width = (self.timeRowHeaderWidth + self.contentMargin.left + ((self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right) * self.collectionView.numberOfSections) + self.contentMargin.right);
    return CGSizeMake(width, height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributes[indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == MSCollectionElementKindDayColumnHeader) {
        return self.dayColumnHeaderAttributes[indexPath];
    }
    else if (kind == MSCollectionElementKindTimeRowHeader) {
        return self.timeRowHeaderAttributes[indexPath];
    }
    return nil;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    if (decorationViewKind == MSCollectionElementKindCurrentTimeIndicator) {
        return self.currentTimeIndicatorAttributes[indexPath];
    }
    else if (decorationViewKind == MSCollectionElementKindCurrentTimeHorizontalGridline) {
        return self.currentTimeHorizontalGridlineAttributes[indexPath];
    }
    else if (decorationViewKind == MSCollectionElementKindVerticalGridline) {
        return self.verticalGridlineAttributes[indexPath];
    }
    else if (decorationViewKind == MSCollectionElementKindHorizontalGridline) {
        return self.horizontalGridlineAttributes[indexPath];
    }
    else if (decorationViewKind == MSCollectionElementKindTimeRowHeaderBackground) {
        return self.timeRowHeaderBackgroundAttributes[indexPath];
    }
    else if (decorationViewKind == MSCollectionElementKindDayColumnHeader) {
        return self.dayColumnHeaderBackgroundAttributes[indexPath];
    }
    return nil;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableIndexSet *visibleSections = [NSMutableIndexSet indexSet];
    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)] enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
        CGRect sectionRect = [self rectForSection:section];
        if (CGRectIntersectsRect(sectionRect, rect)) {
            [visibleSections addIndex:section];
        }
    }];
    
    // Update layout for only the visible sections
    [self prepareSectionLayoutForSections:visibleSections];
    
    // Return the visible attributes (rect intersection)
    return [self.allAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, layoutAttributes.frame);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // Required for sticky headers
    return YES;
}

#pragma mark - CollectionViewScheduleLayout

- (void)initialize
{
    self.needsToPopulateAttributesForAllSections = YES;
    self.cachedDayDateComponents = [NSCache new];
    _cachedStartClassSectionComponents = [NSCache new];
    _cachedEndClassSectionComponents = [NSCache new];
    self.cachedCurrentDateComponents = [NSCache new];
    self.cachedMaxColumnHeight = CGFLOAT_MIN;
    self.cachedEarliestClassSection = -1;
    self.cachedLatestClassSection = -1;
    self.cachedColumnHeights = [NSMutableDictionary new];
    self.cachedEarliestClassSectionIndexs = [NSMutableDictionary new];
    _cachedLatestClassSectionIndexs = [NSMutableDictionary new];
    
    self.registeredDecorationClasses = [NSMutableDictionary new];
    
    self.allAttributes = [NSMutableArray new];
    self.itemAttributes = [NSMutableDictionary new];
    self.dayColumnHeaderAttributes = [NSMutableDictionary new];
    self.dayColumnHeaderBackgroundAttributes = [NSMutableDictionary new];
    self.timeRowHeaderAttributes = [NSMutableDictionary new];
    self.timeRowHeaderBackgroundAttributes = [NSMutableDictionary new];
    self.verticalGridlineAttributes = [NSMutableDictionary new];
    self.horizontalGridlineAttributes = [NSMutableDictionary new];
    self.currentTimeIndicatorAttributes = [NSMutableDictionary new];
    self.currentTimeHorizontalGridlineAttributes = [NSMutableDictionary new];
    
    _classSectionHeight = 80;
    self.sectionWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 194.0 : 254.0);
    self.dayColumnHeaderHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60.0 : 50.0);
    self.timeRowHeaderWidth = kTimeRowHeaderWidth;
    self.currentTimeIndicatorSize = CGSizeMake(self.timeRowHeaderWidth, 10.0);
    self.currentTimeHorizontalGridlineHeight = 1.0;
    self.verticalGridlineWidth = (([[UIScreen mainScreen] scale] == 2.0) ? 0.5 : 1.0);
    self.horizontalGridlineHeight = (([[UIScreen mainScreen] scale] == 2.0) ? 0.5 : 1.0);;
    self.sectionMargin = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.cellMargin = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.contentMargin = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    self.displayHeaderBackgroundAtOrigin = YES;
    self.headerLayoutType = MSHeaderLayoutTypeDayColumnAboveTimeRow;
    
    // Invalidate layout on minute ticks (to update the position of the current time indicator)
    NSDate *oneMinuteInFuture = [[NSDate date] dateByAddingTimeInterval:60];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:oneMinuteInFuture];
    NSDate *nextMinuteBoundary = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    // This needs to be a weak reference, otherwise we get a retain cycle
    MSTimerWeakTarget *timerWeakTarget = [[MSTimerWeakTarget alloc] initWithTarget:self selector:@selector(minuteTick:)];
    self.minuteTimer = [[NSTimer alloc] initWithFireDate:nextMinuteBoundary interval:60 target:timerWeakTarget selector:timerWeakTarget.fireSelector userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.minuteTimer forMode:NSDefaultRunLoopMode];
}

#pragma mark Minute Updates

- (void)minuteTick:(id)sender
{
    // Invalidate cached current date componets (since the minute's changed!)
    [self.cachedCurrentDateComponents removeAllObjects];
    [self invalidateLayout];
}

#pragma mark - Layout

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (self.registeredDecorationClasses[kind] && !(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (!(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (void)invalidateLayoutCache
{
    self.needsToPopulateAttributesForAllSections = YES;
    
    // Invalidate cached Components
    [self.cachedDayDateComponents removeAllObjects];
    [_cachedStartClassSectionComponents removeAllObjects];
    [_cachedEndClassSectionComponents removeAllObjects];
    [self.cachedCurrentDateComponents removeAllObjects];
    
    // Invalidate cached interface sizing values
    self.cachedEarliestClassSection = -1;
    self.cachedLatestClassSection = -1;
    self.cachedMaxColumnHeight = CGFLOAT_MIN;
    [self.cachedColumnHeights removeAllObjects];
    [self.cachedEarliestClassSectionIndexs removeAllObjects];
    [_cachedLatestClassSectionIndexs removeAllObjects];
    
    // Invalidate cached item attributes
    [self.itemAttributes removeAllObjects];
    [self.verticalGridlineAttributes removeAllObjects];
    [self.horizontalGridlineAttributes removeAllObjects];
    [self.dayColumnHeaderAttributes removeAllObjects];
    [self.dayColumnHeaderBackgroundAttributes removeAllObjects];
    [self.timeRowHeaderAttributes removeAllObjects];
    [self.timeRowHeaderBackgroundAttributes removeAllObjects];
    [self.allAttributes removeAllObjects];
}

#pragma mark Dates

- (XujcSection *)classSectionForTimeRowHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger earliestClassSectionIndex = [self earliestClassSection];
    XujcSection *classSection = [XujcSection sectionIndex:earliestClassSectionIndex + indexPath.item];
    return classSection;
}

- (NSDate *)dateForDayColumnHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.delegate collectionView:self.collectionView layout:self dayForSection:indexPath.section] beginningOfDay];
}

#pragma mark Scrolling

- (void)scrollCollectionViewToClosetSectionToCurrentTimeAnimated:(BOOL)animated
{
    if (self.collectionView.numberOfSections != 0) {
        NSInteger closestSectionToCurrentTime = [self closestSectionToCurrentTime];
        CGPoint contentOffset;
        CGRect currentTimeHorizontalGridlineattributesFrame = [self.currentTimeHorizontalGridlineAttributes[[NSIndexPath indexPathForItem:0 inSection:0]] frame];
        CGFloat yOffset;
        if (!CGRectEqualToRect(currentTimeHorizontalGridlineattributesFrame, CGRectZero)) {
            yOffset = nearbyintf(CGRectGetMinY(currentTimeHorizontalGridlineattributesFrame) - (CGRectGetHeight(self.collectionView.frame) / 2.0));
        } else {
            yOffset = 0.0;
        }
        CGFloat xOffset = self.contentMargin.left + ((self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right) * closestSectionToCurrentTime);
        contentOffset = CGPointMake(xOffset, yOffset);

        // Prevent the content offset from forcing the scroll view content off its bounds
        if (contentOffset.y > (self.collectionView.contentSize.height - self.collectionView.frame.size.height)) {
            contentOffset.y = (self.collectionView.contentSize.height - self.collectionView.frame.size.height);
        }
        if (contentOffset.y < 0.0) {
            contentOffset.y = 0.0;
        }
        if (contentOffset.x > (self.collectionView.contentSize.width - self.collectionView.frame.size.width)) {
            contentOffset.x = (self.collectionView.contentSize.width - self.collectionView.frame.size.width);
        }
        if (contentOffset.x < 0.0) {
            contentOffset.x = 0.0;
        }
        [self.collectionView setContentOffset:contentOffset animated:animated];
    }
}

- (NSInteger)closestSectionToCurrentTime
{
    NSDate *currentDate = [[self.delegate currentTimeComponentsForCollectionView:self.collectionView layout:self] beginningOfDay];
    NSTimeInterval minTimeInterval = CGFLOAT_MAX;
    NSInteger closestSection = NSIntegerMax;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        NSDate *sectionDayDate = [self.delegate collectionView:self.collectionView layout:self dayForSection:section];
        NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:sectionDayDate];
        if ((timeInterval <= 0) && ABS(timeInterval) < minTimeInterval) {
            minTimeInterval = ABS(timeInterval);
            closestSection = section;
        }
    }
    return ((closestSection != NSIntegerMax) ? closestSection : 0);
}

#pragma mark Section Sizing

- (CGRect)rectForSection:(NSInteger)section
{
    CGRect sectionRect;
    CGFloat calendarGridMinX = (self.timeRowHeaderWidth + self.contentMargin.left);
    CGFloat sectionWidth = (self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right);
    CGFloat sectionMinX = (calendarGridMinX + self.sectionMargin.left + (sectionWidth * section));
    sectionRect = CGRectMake(sectionMinX, 0.0, sectionWidth, self.collectionViewContentSize.height);
    return sectionRect;
}

- (CGFloat)maxSectionHeight
{
    if (self.cachedMaxColumnHeight != CGFLOAT_MIN) {
        return self.cachedMaxColumnHeight;
    }
    CGFloat maxSectionHeight = 0.0;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        
        NSInteger earliestClassSection = [self earliestClassSection];
        NSInteger latestClassSection = [self latestClassSection];
        CGFloat sectionColumnHeight;
        if ((earliestClassSection != -1) && (latestClassSection != -1)) {
            sectionColumnHeight = (_classSectionHeight * (latestClassSection - earliestClassSection));
        } else {
            sectionColumnHeight = 0.0;
        }
        
        if (sectionColumnHeight > maxSectionHeight) {
            maxSectionHeight = sectionColumnHeight;
        }
    }
    CGFloat headerAdjustedMaxColumnHeight = (self.dayColumnHeaderHeight + self.contentMargin.top + self.sectionMargin.top + maxSectionHeight + self.sectionMargin.bottom + self.contentMargin.bottom);
    if (maxSectionHeight != 0.0) {
        self.cachedMaxColumnHeight = headerAdjustedMaxColumnHeight;
        return headerAdjustedMaxColumnHeight;
    } else {
        return headerAdjustedMaxColumnHeight;
    }
}

- (CGFloat)stackedSectionHeight
{
    return [self stackedSectionHeightUpToSection:self.collectionView.numberOfSections];
}

- (CGFloat)stackedSectionHeightUpToSection:(NSInteger)upToSection
{
    if (self.cachedColumnHeights[@(upToSection)]) {
        return [self.cachedColumnHeights[@(upToSection)] integerValue];
    }
    CGFloat stackedSectionHeight = 0.0;
    for (NSInteger section = 0; section < upToSection; section++) {
        CGFloat sectionColumnHeight = [self sectionHeight:section];
        stackedSectionHeight += sectionColumnHeight;
    }
    CGFloat headerAdjustedStackedColumnHeight = (stackedSectionHeight + ((self.dayColumnHeaderHeight + self.contentMargin.top + self.contentMargin.bottom) * upToSection));
    if (stackedSectionHeight != 0.0) {
        self.cachedColumnHeights[@(upToSection)] = @(headerAdjustedStackedColumnHeight);
        return headerAdjustedStackedColumnHeight;
    } else {
        return headerAdjustedStackedColumnHeight;
    }
}

- (CGFloat)sectionHeight:(NSInteger)section
{
    NSInteger earliestClassSection = [self earliestClassSectionForSection:section];
    NSInteger latestClassSection = [self latestClassSectionForSection:section];
    
    if ((earliestClassSection != -1) && (latestClassSection != -1)) {
        return (_classSectionHeight * (latestClassSection - earliestClassSection));
    } else {
        return 0.0;
    }
}

- (CGFloat)minuteHeight
{
    return (_classSectionHeight / ([XujcSection sectionDuration] / kTimeIntervalOfMinute));
}

#pragma mark Z Index

- (CGFloat)zIndexForElementKind:(NSString *)elementKind
{
    return [self zIndexForElementKind:elementKind floating:NO];
}

- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating
{
    // Current Time Indicator
    if (elementKind == MSCollectionElementKindCurrentTimeIndicator) {
        return (MSCollectionMinOverlayZ + ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 9.0 : 4.0) : (floating ? 7.0 : 2.0)));
    }
    // Time Row Header
    else if (elementKind == MSCollectionElementKindTimeRowHeader) {
        return (MSCollectionMinOverlayZ + ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 8.0 : 3.0) : (floating ? 6.0 : 1.0)));
    }
    // Time Row Header Background
    else if (elementKind == MSCollectionElementKindTimeRowHeaderBackground) {
        return (MSCollectionMinOverlayZ + ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 7.0 : 2.0) : (floating ? 5.0 : 0.0)));
    }
    // Day Column Header
    else if (elementKind == MSCollectionElementKindDayColumnHeader) {
        return (MSCollectionMinOverlayZ + ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 6.0 : 1.0) : (floating ? 9.0 : 4.0)));
    }
    // Day Column Header Background
    else if (elementKind == MSCollectionElementKindDayColumnHeaderBackground) {
        return (MSCollectionMinOverlayZ + ((self.headerLayoutType == MSHeaderLayoutTypeTimeRowAboveDayColumn) ? (floating ? 5.0 : 0.0) : (floating ? 8.0 : 3.0)));
    }
    // Cell
    else if (elementKind == nil) {
        return MSCollectionMinCellZ;
    }
    // Current Time Horizontal Gridline
    else if (elementKind == MSCollectionElementKindCurrentTimeHorizontalGridline) {
        return (MSCollectionMinBackgroundZ + 2.0);
    }
    // Vertical Gridline
    else if (elementKind == MSCollectionElementKindVerticalGridline) {
        return (MSCollectionMinBackgroundZ + 1.0);
    }
    // Horizontal Gridline
    else if (elementKind == MSCollectionElementKindHorizontalGridline) {
        return MSCollectionMinBackgroundZ;
    }
    return CGFLOAT_MIN;
}

#pragma mark Hours

- (NSInteger)earliestClassSection
{
    if (self.cachedEarliestClassSection != -1) {
        return self.cachedEarliestClassSection;
    }
    NSInteger earliestClassSection = 1;
//    NSInteger earliestHour = NSIntegerMax;
//    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
//        CGFloat sectionEarliestHour = [self earliestHourForSection:section];
//        if ((sectionEarliestHour < earliestHour) && (sectionEarliestHour != NSUndefinedDateComponent)) {
//            earliestHour = sectionEarliestHour;
//        }
//    }
    if (earliestClassSection != -1) {
        self.cachedEarliestClassSection = earliestClassSection;
        return earliestClassSection;
    } else {
        return 0;
    }
}

- (NSInteger)latestClassSection
{
    if (self.cachedLatestClassSection != -1) {
        return self.cachedLatestClassSection;
    }
    NSInteger latestClassSection = 12;
//    NSInteger latestHour = NSIntegerMin;
//    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
//        CGFloat sectionLatestHour = [self latestHourForSection:section];
//        if ((sectionLatestHour > latestHour) && (sectionLatestHour != NSUndefinedDateComponent)) {
//            latestHour = sectionLatestHour;
//        }
//    }
    if (latestClassSection != -1) {
        self.cachedLatestClassSection = latestClassSection;
        return latestClassSection;
    } else {
        return 0;
    }
}

- (NSInteger)earliestClassSectionForSection:(NSInteger)section
{
    if (self.cachedEarliestClassSectionIndexs[@(section)]) {
        return [self.cachedEarliestClassSectionIndexs[@(section)] integerValue];
    }
    NSInteger earliestClassSectionIndex = NSIntegerMax;
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        XujcSection *classSection = [self classSectionForTimeRowHeaderAtIndexPath:itemIndexPath];
        if (classSection.sectionIndex < earliestClassSectionIndex) {
            earliestClassSectionIndex = classSection.sectionIndex;
        }
    }
    if (earliestClassSectionIndex != NSIntegerMax) {
        self.cachedEarliestClassSectionIndexs[@(section)] = @(earliestClassSectionIndex);
        return earliestClassSectionIndex;
    } else {
        return 0;
    }
}

- (NSInteger)latestClassSectionForSection:(NSInteger)section
{
    if (_cachedLatestClassSectionIndexs[@(section)]) {
        return [_cachedLatestClassSectionIndexs[@(section)] integerValue];
    }
    NSInteger latestClassSection = NSIntegerMin;
    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        XujcSection *classSection = [self classSectionForTimeRowHeaderAtIndexPath:itemIndexPath];
        if (latestClassSection < classSection.sectionIndex) {
            latestClassSection = classSection.sectionIndex;
        }
    }
    if (latestClassSection != NSIntegerMin) {
        _cachedLatestClassSectionIndexs[@(section)] = @(latestClassSection);
        return latestClassSection;
    } else {
        return 0;
    }
}

#pragma mark Delegate Wrappers

- (NSDateComponents *)dayForSection:(NSInteger)section
{
    if ([self.cachedDayDateComponents objectForKey:@(section)]) {
        return [self.cachedDayDateComponents objectForKey:@(section)];
    }
    
    NSDate *date = [self.delegate collectionView:self.collectionView layout:self dayForSection:section];
    date = [date beginningOfDay];
    NSDateComponents *dayDateComponents = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSEraCalendarUnit) fromDate:date];
    
    [self.cachedDayDateComponents setObject:dayDateComponents forKey:@(section)];
    return dayDateComponents;
}

- (NSInteger)startClassSectionIndexForIndexPath:(NSIndexPath *)indexPath
{
    if ([_cachedStartClassSectionComponents objectForKey:indexPath]) {
        return [[_cachedStartClassSectionComponents objectForKey:indexPath] integerValue];
    }
    
    NSInteger classSectionIndex = [self.delegate collectionView:self.collectionView layout:self startClassSectionIndexForItemAtIndexPath:indexPath];
    
    [_cachedStartClassSectionComponents setObject:@(classSectionIndex) forKey:indexPath];
    return classSectionIndex;
}

- (NSInteger)endClassSectionIndexForIndexPath:(NSIndexPath *)indexPath
{
    if ([_cachedEndClassSectionComponents objectForKey:indexPath]) {
        return [[_cachedEndClassSectionComponents objectForKey:indexPath] integerValue];
    }
    
    NSInteger classSectionIndex = [self.delegate collectionView:self.collectionView layout:self endClassSectionIndexForItemAtIndexPath:indexPath];
    
    [_cachedEndClassSectionComponents setObject:@(classSectionIndex) forKey:indexPath];
    return classSectionIndex;
}

- (NSDateComponents *)currentTimeDateComponents
{
    if ([self.cachedCurrentDateComponents objectForKey:@(0)]) {
        return [self.cachedCurrentDateComponents objectForKey:@(0)];
    }
    
    NSDate *date = [self.delegate currentTimeComponentsForCollectionView:self.collectionView layout:self];
    NSDateComponents *currentTime = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    
    [self.cachedCurrentDateComponents setObject:currentTime forKey:@(0)];
    return currentTime;
}

@end

