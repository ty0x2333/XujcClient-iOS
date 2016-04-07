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
#import <Google/Analytics.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMessage.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

static const CGFloat kWindowCornerRadius = 4.f;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TyLogDebug(@"Document Path: %@", DOCUMENT_DIRECTORY);
#if DEBUG
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    TyLogDebug (@"Current Language: %@" , currentLanguage);
#endif
    
    [UMSocialData setAppKey:kUMengAppKey];
    [UMSocialWechatHandler setWXAppId:kWechatAppID appSecret:kWechatSecret url:@"http://www.tianyiyan.com"];
    [UMSocialQQHandler setQQWithAppId:kQQAppID appKey:kQQAppKey url:@"http://www.tianyiyan.com"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppKey
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    UIImage *shareImage = [UIImage imageNamed:@"logo"];
    UMSocialExtConfig *defaultExtConfig = [UMSocialData defaultData].extConfig;
    // QQ
    defaultExtConfig.qqData.title = kShareTitle;
    defaultExtConfig.qqData.shareText = kShareText;
    defaultExtConfig.qqData.shareImage = shareImage;
    // QZone
    defaultExtConfig.qzoneData.title = kShareTitle;
    defaultExtConfig.qzoneData.shareText = kShareText;
    defaultExtConfig.qzoneData.shareImage = shareImage;
    
#if DEBUG
    [UMSocialData openLog:YES];
#endif
    
    [UMessage startWithAppkey:kUMengAppKey launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        // register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
        acceptAction.identifier = @"AcceptIdentifier";
        acceptAction.title = @"Accept";
        acceptAction.activationMode = UIUserNotificationActivationModeForeground;
        
        UIMutableUserNotificationAction *rejectAction = [[UIMutableUserNotificationAction alloc] init];
        rejectAction.identifier = @"RejectIdentifier";
        rejectAction.title = @"Reject";
        rejectAction.activationMode = UIUserNotificationActivationModeBackground;
        rejectAction.authenticationRequired = YES;
        rejectAction.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"UMessage";
        [categorys setActions:@[acceptAction, rejectAction] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else {
        // register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
#else
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
#endif
    
#if DEBUG
    [UMessage setLogEnabled:YES];
#endif
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
#if DEBUG
    gai.logger.logLevel = kGAILogLevelWarning;  // remove before app release
#endif
    
    [Instabug startWithToken:kInstabugToken invocationEvent:IBGInvocationEventNone];
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    TyLogFatal(@"Fail To Register For Remote Notifications: %@", error);
}

#pragma UMSocialSnsService
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
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
