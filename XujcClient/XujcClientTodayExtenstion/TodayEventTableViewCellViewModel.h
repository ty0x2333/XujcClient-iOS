//
//  TodayEventTableViewCellViewModel.h
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XujcLessonEventModel;

@interface TodayEventTableViewCellViewModel : NSObject

- (instancetype)initWithModel:(XujcLessonEventModel *)model;

@property (nonatomic, readonly, copy) NSString *lessonName;
@property (nonatomic, readonly, copy) NSString *lessonLocation;

@property (nonatomic, readonly, copy) NSString *sectionDescription;

@end
