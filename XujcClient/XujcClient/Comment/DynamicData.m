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

- (void)cleanAllIdentityInformation
{
    UserModel *user = [[UserModel alloc] init];
    _user = user;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"" forKey:kUserDefaultsKeyApiKey];
    [userDefaults setValue:@"" forKey:kUserDefaultsKeyXujcKey];
    [userDefaults setValue:[user data] forKey:kUserDefaultsKeyUser];
    [userDefaults synchronize];
}

- (void)cleanApiKey
{
    [self setApiKey:@""];
}

- (void)cleanXujcKey
{
    [self setXujcKey:@""];
}

#pragma mark - Setter

- (void)setApiKey:(NSString *)apiKey
{
    if ([apiKey isEqualToString:self.apiKey]) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString safeString:apiKey] forKey:kUserDefaultsKeyApiKey];
    [userDefaults synchronize];
}

- (void)setXujcKey:(NSString *)xujcKey
{
    if ([xujcKey isEqualToString:self.xujcKey]) {
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString safeString:xujcKey] forKey:kUserDefaultsKeyXujcKey];
    [userDefaults synchronize];
}

- (void)setUser:(UserModel *)user
{
    if (_user == user) {
        return;
    }
    _user = user;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[_user data] forKey:kUserDefaultsKeyUser];
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
