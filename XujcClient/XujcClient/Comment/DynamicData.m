/**
 * @file DynamicData.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "DynamicData.h"

@implementation DynamicData

+ (instancetype)instance
{
    static DynamicData *shareDynamicDataInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareDynamicDataInstance = [[self alloc] init];
    });
    return shareDynamicDataInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        [self loadingSettings];
    }
    return self;
}

#pragma mark - Load And Flush

- (void)loadingSettings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    _user = [NSKeyedUnarchiver unarchiveObjectWithData:[userDefaults objectForKey:kUserDefaultsKeyUser]];
    TyLogDebug(@"DynamicData Loaded:%@", [self description]);
}

- (void)flush
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[_user data] forKey:kUserDefaultsKeyUser];
    
    TyLogDebug(@"DynamicData Flush:%@", [self description]);
    
    [userDefaults synchronize];
}

- (void)clear
{
    UserModel *user = [[UserModel alloc] init];
    _user = user;
    [self flush];
}

#pragma mark - Setter

- (void)setXujcKey:(NSString *)xujcKey
{
    if ([xujcKey isEqualToString:self.xujcKey]) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString safeString:xujcKey] forKey:kUserDefaultsKeyXujcKey];
    [userDefaults synchronize];
}

#pragma mark - Getter

- (NSString *)apiKey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyApiKey];
}

- (BOOL)shakingReportStatus
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyShakingReportStatus];
}

- (NSString *)xujcKey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsKeyXujcKey];
}

#pragma mark - Other

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n\tAPIKey: %@, \n\tXujcKey: %@, \n\tUser: %@\n}", self.apiKey, self.xujcKey, [_user description]];
}

@end
