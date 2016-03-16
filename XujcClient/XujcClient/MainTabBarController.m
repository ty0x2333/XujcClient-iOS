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

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        [self presentViewController:viewController animated:NO completion:nil];
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
    UINavigationController *scheduleNavViewController = [[UINavigationController alloc] initWithRootViewController:[[ScheduleViewController alloc] initWithViewModel:self.viewModel.scheduleViewModel]];
    UINavigationController *scoreNavViewController = [[UINavigationController alloc] initWithRootViewController:[[ScoreViewController alloc] initWithViewModel:self.viewModel.scoreViewModel]];
    UINavigationController *personalNavViewController = [[UINavigationController alloc] initWithRootViewController:[[PersonalViewController alloc] init]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
