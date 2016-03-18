//
//  UITabBarController+animation.m
//  XujcClient
//
//  Created by 田奕焰 on 16/3/19.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import "UITabBarController+animation.h"

static CGFloat const kTabBarAnimationDuration = .3f;

@implementation UITabBarController (animation)

- (void)ty_setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    if ([self ty_tabBarIsVisible] == visible) return (completion)? completion(YES) : nil;
    
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBar.bounds);
    CGFloat offsetY = visible ? -tabBarHeight : tabBarHeight;
    
    CGFloat duration = animated ? kTabBarAnimationDuration : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBar.frame = CGRectOffset(self.tabBar.frame, 0, offsetY);
    } completion:completion];
}

- (BOOL)ty_tabBarIsVisible
{
    return CGRectGetMinY(self.tabBar.frame) < CGRectGetMaxY(self.view.frame);
}

@end
