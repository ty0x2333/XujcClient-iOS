/**
 * @file DynamicData.h
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "UserModel.h"

#define DYNAMIC_DATA [DynamicData instance]

@interface DynamicData : NSObject

+ (instancetype)instance;

- (instancetype)init;

- (void)loadingSettings;

- (void)flush;

- (void)cleanAll;

- (void)cleanApiKey;

- (void)cleanXujcKey;

@property (nonatomic, strong) UserModel *user;

@property (copy, nonatomic) NSString *apiKey;

@property (copy, nonatomic) NSString *xujcKey;

@property (assign, readonly, nonatomic) BOOL shakingReportStatus;

@end
