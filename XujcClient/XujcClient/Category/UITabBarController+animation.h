//
//  UITabBarController+animation.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/19.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (animation)

- (void)ty_setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL))completion;

- (BOOL)ty_tabBarIsVisible;

@end
