//
//  LessonEventPopView.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <MMPopupView/MMPopupView.h>
@class LessonEventPopViewModel;

@interface LessonEventPopView : MMPopupView

- (instancetype)initWithViewModel:(LessonEventPopViewModel *)viewModel;

@end
