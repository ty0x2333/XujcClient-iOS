//
//  AppConfig.h
//  XujcClient
//
//  Created by 田奕焰 on 16/3/6.
//  Copyright © 2016年 luckytianyiyan. All rights reserved.
//

#ifndef AppConfig_h
#define AppConfig_h

static CGFloat const kErrorHUDShowTime = 2.f;
static CGFloat const kSuccessHUDShowTime = 2.f;

static NSString * const kUserDefaultsKeyApiKey = @"api_key";
static NSString * const kUserDefaultsKeyShakingReportStatus = @"shaking_report";
static NSString * const kUserDefaultsKeyXujcKey = @"xujc_key";
static NSString * const kUserDefaultsKeyUser = @"user";

static NSString * const kInstabugToken = @"f0a9d84167a85899070415ed37f5d1b2";

static NSString * const kUMengAppKey = @"56f14cc1e0f55a639e001151";

static NSString * const kWechatAppID = @"wxb3bd91f1750f789c";
static NSString * const kWechatSecret = @"827cca319bce299221eac7eef6cabe25";

static NSString * const kQQAppID = @"1105288624";
static NSString * const kQQAppKey = @"fjUdIUCeMaiH5JAW";

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define DOCUMENT_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#endif /* AppConfig_h */
