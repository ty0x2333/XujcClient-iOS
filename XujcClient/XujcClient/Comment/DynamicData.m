/**
 * @file DynamicData.m
 *
 * @author luckytianyiyan@gmail.com
 * @date 15/10/31
 * @copyright   Copyright © 2015年 luckytianyiyan. All rights reserved.
 */

#import "DynamicData.h"

static NSString* const kDataXujcUser = @"XujcUser";
static NSString* const kDataXujcAPIKey = @"APIKey";


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
    NSDictionary *user = [userDefaults dictionaryForKey:kDataXujcUser];
    _user = [[XujcUser alloc] initWithDictionary:user];
    _APIKey = [userDefaults stringForKey:kDataXujcAPIKey];
    TyLogDebug(@"DynamicData Loaded:%@", [self description]);
}

- (void)flush
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [_user dictionaryRepresentation];
    [userDefaults setObject:dict forKey:kDataXujcUser];
    [userDefaults setObject:_APIKey forKey:kDataXujcAPIKey];
    [userDefaults synchronize];
    TyLogDebug(@"DynamicData Flush:%@", [self description]);
}

- (void)clear
{
    XujcUser *user = [[XujcUser alloc] init];
    _user = user;
    [self flush];
}

#pragma mark - Other

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\n\tAPIKey: %@\n\tUser: %@\n}", _APIKey, [_user description]];
}

@end
