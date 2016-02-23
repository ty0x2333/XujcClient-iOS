//
//  UIView+BorderLine.h
//  XujcClient
//
//  Created by 田奕焰 on 16/2/24.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BorderLine)

@property (nonatomic, assign) CGColorRef ty_borderColor;
@property (nonatomic, assign) UIRectEdge ty_borderEdge;
@property (nonatomic, assign) CGFloat ty_borderWidth;

@end
