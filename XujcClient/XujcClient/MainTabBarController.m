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
#import "DynamicData.h"
@interface MainTabBarController ()

@property (strong, nonatomic) MainTabBarViewModel *viewModel;

@end

@implementation MainTabBarController

- (instancetype)initWithModel:(MainTabBarViewModel *)viewModel
{
    if (self = [super init]) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationController *scheduleNavViewController = [[UINavigationController alloc] initWithRootViewController:[[ScheduleViewController alloc] initWithViewModel:self.viewModel.scheduleViewModel]];
    UINavigationController *scoreNavViewController = [[UINavigationController alloc] initWithRootViewController:[[ScoreViewController alloc] init]];
    UINavigationController *personalNavViewController = [[UINavigationController alloc] initWithRootViewController:[[PersonalViewController alloc] init]];
    self.viewControllers = @[
                             scheduleNavViewController,
                             [[UIViewController alloc] init],
                             scoreNavViewController,
                             personalNavViewController
                             ];
    
    NSArray *titles = @[@"课程表", @"考试安排", @"成绩查询", @"个人"];
    NSArray *images = @[@"tabbar-schedule", @"tabbar-exam", @"tabbar-search", @"tabbar-personal"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        [item setImage:[UIImage imageNamed:images[idx]]];
        [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([NSString isEmpty:DYNAMIC_DATA.apiKey]){
        LoginViewController *viewController = [[LoginViewController alloc] init];
        [self presentViewController:viewController animated:NO completion:nil];
        return;
    }
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
