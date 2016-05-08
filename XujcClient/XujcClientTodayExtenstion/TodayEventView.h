//
//  TodayEventView.h
//  XujcClient
//
//  Created by 田奕焰 on 16/5/8.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TodayEventViewModel;

@interface TodayEventView : UIView

- (instancetype)initWithViewModel:(TodayEventViewModel *)viewModel;

@property (nonatomic, copy) NSString *lessonName;
@property (nonatomic, copy) NSString *lessonLocation;

@property (nonatomic, copy) NSString *sectionDescription;

@end
