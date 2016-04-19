//
//  ScheduleTheme.h
//  XujcClient
//
//  Created by 田奕焰 on 16/4/20.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleTheme : NSObject

+ (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted;

+ (UIColor *)textColorHighlighted:(BOOL)selected;

+ (UIColor *)backgroundColorHighlighted:(BOOL)selected;

@end
