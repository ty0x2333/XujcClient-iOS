/**
 * @file MainTabBarController.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "MainTabBarController.h"
#import "ScheduleViewController.h"
#import "ScoreViewController.h"
#import "PersonalViewController.h"
#import "LoginViewController.h"
#import "BindingAccountViewController.h"
#import "DynamicData.h"
#import "UITabBarController+animation.h"

static CGFloat const kTabBarOpacity = .9f;

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.layer.opacity = kTabBarOpacity;
    [self.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    RACSignal *disappearSignal = [self rac_signalForSelector:@selector(viewDidDisappear:)];
    
    @weakify(self);
    [[[[[RACSignal combineLatest:@[self.viewModel.apiKeyInactiveSignal]] takeUntil:disappearSignal] setNameWithFormat:@"MainTabBarController loginSignal"] logAll] subscribeNext:^(id x) {
        @strongify(self);
        LoginViewController *viewController = [[LoginViewController alloc] initWithLoginViewModel:_viewModel.loginViewModel andSignupViewModel:_viewModel.signupViewModel];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navController animated:NO completion:nil];
    }];
    
    [[[[[RACSignal combineLatest:@[self.viewModel.apiActiveKeySignal, self.viewModel.xujcKeyInactiveSignal]] takeUntil:disappearSignal] setNameWithFormat:@"MainTabBarController bindingSignal"] logAll] subscribeNext:^(id x) {
        @strongify(self);
        BindingAccountViewController *viewController = [[BindingAccountViewController alloc] initWithViewModel:self.viewModel.bindingAccountViewModel];
        [self presentViewController:viewController animated:NO completion:nil];
    }];
}

- (void)setViewModel:(MainTabBarViewModel *)viewModel
{
    _viewModel = viewModel;
    UINavigationController *scheduleNavViewController = [self p_navigationControllerWithRootViewController:[[ScheduleViewController alloc] initWithViewModel:self.viewModel.scheduleViewModel]];
    UINavigationController *scoreNavViewController = [self p_navigationControllerWithRootViewController:[[ScoreViewController alloc] initWithViewModel:self.viewModel.scoreViewModel]];

    UINavigationController *personalNavViewController = [self p_navigationControllerWithRootViewController:[[PersonalViewController alloc] initWithViewModel:self.viewModel.personalViewModel]];
    self.viewControllers = @[
                             scheduleNavViewController,
//                             [[UIViewController alloc] init],
                             scoreNavViewController,
                             personalNavViewController
                             ];
    
    NSArray *images = @[@"tabbar-schedule",
//                        @"tabbar-exam",
                        @"tabbar-search",
                        @"tabbar-personal"
                        ];
    
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }];
}

- (UINavigationController *)p_navigationControllerWithRootViewController:(UIViewController *)viewController
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    @weakify(self);
    RACSignal *popToRootSignal = [navController rac_signalForSelector:@selector(popToRootViewControllerAnimated:)];
    RACSignal *popToViewControllerSignal = [[navController rac_signalForSelector:@selector(popToViewController:animated:)] filter:^BOOL(id value) {
        return @(navController.viewControllers.count < 2);
    }];
    RACSignal *popViewControllerSignal = [[navController rac_signalForSelector:@selector(popViewControllerAnimated:)] filter:^BOOL(id value) {
        return @(navController.viewControllers.count < 2);
    }];
    RACSignal *popSignal = [RACSignal merge:@[popToRootSignal, popToViewControllerSignal, popViewControllerSignal]];
    
    [[popSignal filter:^BOOL(id value) {
        @strongify(self);
        return ![self ty_tabBarIsVisible];
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self ty_setTabBarVisible:YES animated:YES completion:nil];
    }];
    
    [[[navController rac_signalForSelector:@selector(pushViewController:animated:)] filter:^BOOL(id value) {
        @strongify(self);
        return [self ty_tabBarIsVisible];
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self ty_setTabBarVisible:NO animated:YES completion:nil];
    }];
    return navController;
}

@end
