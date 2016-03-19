//
//  AppDelegate.m
//  XujcClient
//
//  Created by 田奕焰 on 15/10/30.
//  Copyright © 2015年 luckytianyiyan. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "DynamicData.h"
#import "CacheUtils.h"
#import <MMPopupWindow.h>
#import <Instabug/Instabug.h>

static const CGFloat kWindowCornerRadius = 4.f;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TyLogDebug(@"Document Path: %@", DOCUMENT_DIRECTORY);
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    TyLogDebug (@"Current Language: %@" , currentLanguage);
    
    [Instabug startWithToken:kInstabugToken invocationEvent:IBGInvocationEventShake];
    
    [CacheUtils instance];
    
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    // Override point for customization after application launch.
    _masterViewModel = [[MasterViewModel alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    MainTabBarController *mainTabBarController = [[MainTabBarController alloc] init];
    mainTabBarController.viewModel = _masterViewModel.mainTabBarViewModel;
    
    self.window.rootViewController = mainTabBarController;
    self.window.layer.cornerRadius = kWindowCornerRadius;
    self.window.layer.masksToBounds = YES;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
